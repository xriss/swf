/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.regexp.AsciiUtil;
import org.as2lib.regexp.PatternSyntaxException;
import org.as2lib.regexp.Matcher;
import org.as2lib.regexp.node.*;
import org.as2lib.core.BasicClass;

/**
 * {@code Pattern} provides implementations of the parsing engine for 
 * basic RegExp constructs.
 * 
 * @author Igor Sadovskiy
 * @see org.as2lib.regexp.Matcher
 * @see org.as2lib.regexp.PosixPattern
 */

class org.as2lib.regexp.Pattern extends BasicClass
{

    /**
     * Enables Unix lines mode.
     */
    public static var UNIX_LINES:Number = 0x01;

    /**
     * Enables case-insensitive matching.
     */
    public static var CASE_INSENSITIVE:Number = 0x02;

    /**
     * Permits whitespace and comments in pattern.
     */
    public static var COMMENTS:Number = 0x04;

    /**
     * Enables multiline mode.
     */
    public static var MULTILINE:Number = 0x08;

    /**
     * Enables dotall mode.
     */
    public static var DOTALL:Number = 0x20;

    /**
     * Enables Unicode-aware case folding.
     */
    public static var UNICODE_CASE:Number = 0x40;


    /**
     * The original regular-expression pattern string.
     */
    private var pattern:String;

    /**
     * The original pattern flags.
     */
    private var flags:Number;

    /**
     * The starting point of state machine for the find operation.
     */
    private var root:Node;

    /**
     * The root of object tree for a match operation.  The pattern is matched
     * at the beginning.  This may include a find that uses BnM or a First
     * node.
     */
    public var matchRoot:Node;

    /**
     * Temporary storage used by parsing pattern slice.
     */
    private var buffer:Array;

    /**
     * Temporary storage used while parsing group references.
     */
    private var groupNodes:Array;

    /**
     * Temporary null terminating char array used by pattern compiling.
     */
    private var temp:Array;

    /**
     * The group count of this Pattern. Used by matchers to allocate storage
     * needed to perform a match.
     */
    private var groupCount:Number;

    /**
     * The local variable count used by parsing tree. Used by matchers to
     * allocate storage needed to perform a match.
     */
    private var localCount:Number;

    /**
     * Index into the pattern string that keeps track of how much has been
     * parsed.
     */
    private var cursor:Number;

    /**
     * Holds the length of the pattern string.
     */
    private var patternLength:Number;


    public function Pattern(newPattern:String, newFlags:Number) {
    	super();
    	
	 	if (!ACCEPT) {
	    	ACCEPT = new Node();
	  	}
	  	if (!LASTACCEPT) {
	    	LASTACCEPT = new LastNode();
	  	}
    	
        pattern = newPattern;
        flags = (newFlags != null) ? newFlags : 0;
        
		cursor = 0;        

        // reset group index and count
        groupCount = 1;
        localCount = 0;

        if (pattern.length > 0) {
            compile();
        } else {
            root = new Start(LASTACCEPT);
            matchRoot = LASTACCEPT;
        }
    }

    public function getPattern(Void):String {
        return pattern;
    }

    public function getMatcher(input:String):Matcher {
        var m:Matcher = new Matcher(this, input);
        return m;
    }

    public function getFlags(Void):Number {
        return flags;
    }

    public static function matches(pattern:String, input:String):Boolean {
        var p:Pattern = new Pattern(pattern);
        var m:Matcher = p.getMatcher(input);
        return m.matches();
    }

    public function split(input:String, limit:Number):Array { 
    	if (limit == null) {
    		limit = 0;
    	}
        var index:Number = 0;
        var matchLimited:Boolean = limit > 0;
        var matchList:Array = new Array();
        var m:Matcher = getMatcher(input);

        // Add segments before each match found
        while (m.find()) {
            if (!matchLimited || matchList.length < limit - 1) {
                var match:String = input.substring(index, m.getStartIndex());
                matchList.push(match);
                index = m.getEndIndex();
            } else if (matchList.length == limit - 1) { // last one
                var match:String = input.substring(index, input.length);
                matchList.push(match);
                index = m.getEndIndex();
            }
        }

        // If no match was found, return this
        if (index == 0) {
        	return [input.toString()];
        }

        // Add remaining segment
        if (!matchLimited || matchList.length < limit) {
            matchList.push(input.substring(index, input.length));
        }

        // Construct result
        var resultSize:Number = matchList.length;
        if (limit == 0) {
            while (resultSize > 0 && matchList[resultSize-1].equals("")) {
                resultSize--;
            }
        }
        return matchList.slice(0, resultSize);
    }

    private function compile(Void):Void {
        // Copy pattern to char array for convenience
        patternLength = pattern.length;
        temp = new Array(patternLength + 2);

        // Use double null characters to terminate pattern
        temp = toCharCodeArray(pattern);
        temp[patternLength] = 0;
        temp[patternLength + 1] = 0;
		
        // Allocate all temporary objects here.
        buffer = new Array(32);
        groupNodes = new Array(10);
        
        // Start recursive decedent parsing
        matchRoot = parseExpression(LASTACCEPT);

        // Check extra pattern characters
        if (patternLength != cursor) {
            if (peekChar() == AsciiUtil.CHAR_RPAR) {
                throwError("Unmatched closing ')'", arguments);
            } else {
                throwError("Unexpected internal error", arguments);
            }
        }

        // Peephole optimization
        if (matchRoot instanceof Slice) {
            root = BnM.optimize(matchRoot);
            if (root == matchRoot) {
                root = new Start(matchRoot);
            }
        } else if (matchRoot instanceof Begin || matchRoot instanceof First) {
            root = matchRoot;
        } else {
            root = new Start(matchRoot);
        }

        // Release temporary storage
        temp = null;
        buffer = null;
        groupNodes = null;
        patternLength = 0;
    }

    private static function printObjectTree(node:Node):Void {
        while (node != null) {
            if (node instanceof Prolog) {
	            trace(node);
                printObjectTree((Prolog(node)).getLoop());
                trace("**** end contents prolog loop");
            } else if (node instanceof Loop) {
                trace(node);
                printObjectTree((Loop(node)).getBody());
                trace("**** end contents Loop body");
            } else if (node instanceof Curly) {
                trace(node);
                printObjectTree((Curly(node)).getAtom());
                trace("**** end contents Curly body");
            } else if (node instanceof GroupTail) {
                trace(node);
                trace("Tail next is "+node.getNext());
                return;
            } else {
                trace(node);
            }      
            node = node.getNext();
            if (node != null) {
                trace("->next:");
            }
            if (node == Pattern.ACCEPT) {
                trace("Accept Node");
                node = null;
            }
    	}
    }

    private function hasFlag(f:Number):Boolean {
        return (flags & f) > 0;
    }

    private function acceptChar(ch:Number, s:String):Void {
        var testChar:Number = temp[cursor++];
        if (hasFlag(COMMENTS)) {
            testChar = parsePastWhitespace(testChar);
    	}
        if (ch != testChar) {
           throwError(s, arguments);
        }
    }

    private function markChar(c:Number):Void {
        temp[patternLength] = c;
    }

    private function peekChar(Void):Number {
        var ch:Number = temp[cursor];
        if (hasFlag(COMMENTS)) {
            ch = peekPastWhitespace(ch);
        }
        return ch;
    }

    private function readChar(Void):Number {
        var ch:Number = temp[cursor++];
        if (hasFlag(COMMENTS)) {
            ch = parsePastWhitespace(ch);
        }
        return ch;
    }

    private function readEscapedChar(Void):Number {
        var ch:Number = temp[cursor++];
        return ch;
    }

    private function nextChar(Void):Number {
        var ch:Number = temp[++cursor];
        if (hasFlag(COMMENTS)) {
            ch = peekPastWhitespace(ch);
        }
        return ch;
    }

    private function nextEscapedChar(Void):Number {
        var ch:Number = temp[++cursor];
        return ch;
    }

    private function peekPastWhitespace(ch:Number):Number {
        while (AsciiUtil.isSpace(ch) || ch == AsciiUtil.CHAR_NUM) {
            while (AsciiUtil.isSpace(ch)) {
                ch = temp[++cursor];
            }
            if (ch == AsciiUtil.CHAR_NUM) {
                ch = peekPastLine();
            }
        }
        return ch;
    }

    private function parsePastWhitespace(ch:Number):Number {
        while (AsciiUtil.isSpace(ch) || ch == AsciiUtil.CHAR_NUM) {
            while (AsciiUtil.isSpace(ch)) {
                ch = temp[cursor++];
            }
            if (ch == AsciiUtil.CHAR_NUM) {
                ch = parsePastLine();
            }
        }
        return ch;
    }

    private function parsePastLine(Void):Number {
        var ch:Number = temp[cursor++];
        while (ch != 0 && !isLineSeparator(ch)) {
            ch = temp[cursor++];
        }
        return ch;
    }

    private function peekPastLine(Void):Number {
        var ch:Number = temp[++cursor];
        while (ch != 0 && !isLineSeparator(ch)) {
            ch = temp[++cursor];
        }
        return ch;
    }

    private function isLineSeparator(ch:Number):Boolean {
        if (hasFlag(UNIX_LINES)) {
            return (ch == AsciiUtil.CHAR_LF);
        } else {
            return (ch == AsciiUtil.CHAR_LF ||
                    ch == AsciiUtil.CHAR_CR ||
                    (ch|1) == 0x2029 ||
                    ch == 0x0085);
        }
    }

    private function skipChar(Void):Number {
        var i:Number = cursor;
        var ch:Number = temp[i+1];
        cursor = i + 2;
        return ch;
    }

    private function unreadChar(Void):Void {
        cursor--;
    }

    private function throwError(desc:String, args:FunctionArguments):Void {
		throw new PatternSyntaxException(desc, this, args);
    }

    private function parseExpression(end:Node):Node {
        var prev:Node = null;
        while (true) {
            var node:Node = parseSequence(end);
            if (prev == null) {
                prev = node;
            } else {
                prev = new Branch(prev, node);
            }
            if (peekChar() != AsciiUtil.CHAR_VERBAR) {
                return prev;
            }
            nextChar();
        }
    }

    private function parseSequence(end:Node):Node {
        var head:Node = null;
        var tail:Node = null;
        var node:Node = null;
        var i, j:Number;
        var ch :Number;
        while (true) {
            ch = peekChar();
            if (ch == AsciiUtil.CHAR_LPAR) {
                // Because group handles its own closure,
                // we need to treat it differently
                node = parseGroup();
                
                // Check for comment or flag group
                if (node == null) {
                	continue;
                }
                if (head == null) {
                    head = node;
                } else {
                    tail.setNext(node);
                }
                // Double return:Tail was returned in root
                tail = root;
                continue;
            } else if (ch == AsciiUtil.CHAR_LSQB) {
                node = parseClass(true);
            } else if (ch == AsciiUtil.CHAR_BSOL) {
                ch = nextEscapedChar();
                if (ch == AsciiUtil.CHAR_LOW_P || ch == AsciiUtil.CHAR_P) {
                    var comp:Boolean = (ch == AsciiUtil.CHAR_P);
                    var oneLetter:Boolean = true;
                    ch = nextChar(); 
                    // Consume figure bracket if present
                    if (ch != AsciiUtil.CHAR_LCUB) {
                        unreadChar();
                    } else {
                        oneLetter = false;
                    }
                    node = parseFamily(comp, oneLetter);
                } else {
                    unreadChar();
                    node = parseAtom();
                }
            }
            else if (ch == AsciiUtil.CHAR_CIRC) {
                nextChar();
                if (hasFlag(MULTILINE)) {
                    if (hasFlag(UNIX_LINES)) {
                        node = new UnixCaret();
                    } else {
                        node = new Caret();
                    }
                } else {
                    node = new Begin();
                }
            }
            else if (ch == AsciiUtil.CHAR_DOLLAR) {
                nextChar();
                if (hasFlag(UNIX_LINES)) {
                    node = new UnixDollar(hasFlag(MULTILINE));
                } else {
                    node = new Dollar(hasFlag(MULTILINE));
                }
            }
            else if (ch == AsciiUtil.CHAR_PERIOD) {
                nextChar();
                if (hasFlag(DOTALL)) {
                    node = new All();
                } else {
                    if (hasFlag(UNIX_LINES)) {
                        node = new UnixDot();
                    } else {
                        node = new Dot();
                    }
                }
            }
            else if (ch == AsciiUtil.CHAR_VERBAR || ch == AsciiUtil.CHAR_RPAR) {
                break;
            }
            // Now interpreting dangling square and figure brackets as literals
            else if (ch == AsciiUtil.CHAR_RSQB || ch == AsciiUtil.CHAR_RCUB) {
                node = parseAtom();
            }
            else if (ch == AsciiUtil.CHAR_QUEST || ch == AsciiUtil.CHAR_AST || ch == AsciiUtil.CHAR_PLUS) {
                nextChar();
                throwError("Dangling meta character '" + chr(ch) + "'", arguments);
            }
            else { 
	            if (ch == AsciiUtil.CHAR_NUL) {
	                if (cursor >= patternLength) {
	                    break;
	                }
	            }
                node = parseAtom();
            }

            node = parseClosure(node);

            if (head == null) {
                head = tail = node;
            } else {
                tail.setNext(node);
                tail = node;
            }
        }
        if (head == null) {
            return end;
        }
        tail.setNext(end);
        return head;
    }

    private function parseAtom(Void):Node {
        var first:Number = 0;
        var prev:Number = -1;
        var ch:Number = peekChar();
        while (true) {
        	if (ch == AsciiUtil.CHAR_AST ||
        		ch == AsciiUtil.CHAR_PLUS ||
        		ch == AsciiUtil.CHAR_QUEST ||
        		ch == AsciiUtil.CHAR_LCUB ) 
    		{
                if (first > 1) {
                	// Unwind one character
                    cursor = prev;    
                    first--;
                }
        	} else if (ch == AsciiUtil.CHAR_DOLLAR ||
        			 ch == AsciiUtil.CHAR_PERIOD ||
        			 ch == AsciiUtil.CHAR_CIRC ||
        			 ch == AsciiUtil.CHAR_LPAR ||
        			 ch == AsciiUtil.CHAR_LSQB ||
        			 ch == AsciiUtil.CHAR_VERBAR ||
        			 ch == AsciiUtil.CHAR_RPAR	)
        	{
                // skip char
        	} else if (ch == AsciiUtil.CHAR_BSOL) { 
                ch = nextEscapedChar();
                if (ch == AsciiUtil.CHAR_LOW_P || ch == AsciiUtil.CHAR_P) { 
                	// Property
                    if (first > 0) { 
                    	// Slice is waiting; handle it first
                        unreadChar();
                    } else { // No slice; just return the family node
                        if (ch == AsciiUtil.CHAR_LOW_P || ch == AsciiUtil.CHAR_P) {
                            var comp:Boolean = (ch == AsciiUtil.CHAR_P);
                            var oneLetter:Boolean = true;
                            ch = nextChar(); 
                            if (ch != AsciiUtil.CHAR_LCUB) {
                                unreadChar();
                            } else {
                                oneLetter = false;
                            }
                            return parseFamily(comp, oneLetter);
                        }
                    }
                } else {
	                unreadChar();
	                prev = cursor;
	                ch = parseEscape(false, first == 0);
	                if (ch != null) {
	                    appendChar(ch, first);
	                    first++;
	                    ch = peekChar();
	                    continue;
	                } else if (first == 0) {
	                    return root;
	                }
	                // Unwind meta escape sequence
	                cursor = prev;
                }
        	} else {
        		if (ch == AsciiUtil.CHAR_NUL) {
	                if (cursor >= patternLength) {
	                    break;
	                }
        		}
                prev = cursor;
                appendChar(ch, first);
                first++;
                ch = nextChar();
                continue;
            }
            break;
        }
        if (first == 1) {
            return ceateSingle(buffer[0]);
        } else {
            return createSlice(buffer, first);
        }
    }

    private function appendChar(ch:Number, len:Number):Void {
        buffer[len] = ch;
    }

   private function parseBackRef(refNum:Number):Node {
        var done:Boolean = false;
        while (!done) {
            var ch:Number = peekChar();
            switch(ch) {
                case AsciiUtil.CHAR_0:
                case AsciiUtil.CHAR_1:
                case AsciiUtil.CHAR_2:
                case AsciiUtil.CHAR_3:
                case AsciiUtil.CHAR_4:
                case AsciiUtil.CHAR_5:
                case AsciiUtil.CHAR_6:
                case AsciiUtil.CHAR_7:
                case AsciiUtil.CHAR_8:
                case AsciiUtil.CHAR_9:
                    var newRefNum:Number = (refNum * 10) + (ch - AsciiUtil.CHAR_0);
                    // Add another number if it doesn't make a group
                    // that doesn't exist
                    if (groupCount - 1 < newRefNum) {
                        done = true;
                        break;
                    }
                    refNum = newRefNum;
                    readChar();
                    break;
                default:
                    done = true;
                    break;
            }
        }
        if (hasFlag(CASE_INSENSITIVE)) {
            return new BackRefA(refNum);
        } else {
            return new BackRef(refNum);
        }
    }

    private function parseEscape(inclass:Boolean, create:Boolean):Number {
        var ch:Number = skipChar();
        switch (ch) {
            case AsciiUtil.CHAR_0:
                return parseOctal();
            case AsciiUtil.CHAR_1:
            case AsciiUtil.CHAR_2:
            case AsciiUtil.CHAR_3:
            case AsciiUtil.CHAR_4:
            case AsciiUtil.CHAR_5:
            case AsciiUtil.CHAR_6:
            case AsciiUtil.CHAR_7:
            case AsciiUtil.CHAR_8:
            case AsciiUtil.CHAR_9:
                if (inclass) {
                	break;
                }
                if (groupCount < (ch - AsciiUtil.CHAR_0)) {
                    throwError("No such group yet exists at this point in the pattern", arguments);
                }
                if (create) {
                    root = parseBackRef(ch - AsciiUtil.CHAR_0);
                }
                return null;
            case AsciiUtil.CHAR_A:
                if (inclass) {
                	break;
                }
                if (create) {
                	root = new Begin();
                }
                return null;
            case AsciiUtil.CHAR_B:
                if (inclass) {
                	break;
                }
                if (create) {
                	root = new Bound(Bound.NONE);
                }
                return null;
            case AsciiUtil.CHAR_C:
                break;
            case AsciiUtil.CHAR_D:
                if (create) {
                	root = new NotPosix(AsciiUtil.DIGIT);
                }
                return null;
            case AsciiUtil.CHAR_E:
            case AsciiUtil.CHAR_F:
                break;
            case AsciiUtil.CHAR_G:
                if (inclass) {
                	break;
                }
                if (create) {
                	root = new LastMatch();
                }
                return null;
            case AsciiUtil.CHAR_H:
            case AsciiUtil.CHAR_I:
            case AsciiUtil.CHAR_J:
            case AsciiUtil.CHAR_K:
            case AsciiUtil.CHAR_L:
            case AsciiUtil.CHAR_M:
            case AsciiUtil.CHAR_N:
            case AsciiUtil.CHAR_O:
            case AsciiUtil.CHAR_P:
                break;
            case AsciiUtil.CHAR_Q:
                if (create) {
                    // Disable metacharacters. We will return a slice
                    // up to the next \E
                    var i:Number = cursor;
                    var c:Number;
                    while ((c = readEscapedChar()) != 0) {
                        if (c == AsciiUtil.CHAR_BSOL) {
                            c = readEscapedChar();
                            if (c == AsciiUtil.CHAR_E || c == 0) break;
                        }
                    }
                    var j:Number = cursor-1;
                    if (c == AsciiUtil.CHAR_E) {
                        j--;
                    } else {
                        unreadChar();
                    }
                    for (var x = i; x < j; x++) {
                        appendChar(temp[x], x-i);
                    }
                    root = createSlice(buffer, j-i);
                }
                return null;
            case AsciiUtil.CHAR_R:
                break;
            case AsciiUtil.CHAR_S:
                if (create) {
                	root = new NotPosix(AsciiUtil.SPACE);
                }
                return null;
            case AsciiUtil.CHAR_T:
            case AsciiUtil.CHAR_U:
            case AsciiUtil.CHAR_V:
                break;
            case AsciiUtil.CHAR_W:
                if (create) {
                	root = new NotPosix(AsciiUtil.WORD);
                }
                return null;
            case AsciiUtil.CHAR_X:
            case AsciiUtil.CHAR_Y:
                break;
            case AsciiUtil.CHAR_Z:
                if (inclass) break;
                if (create) {
                    if (hasFlag(UNIX_LINES)) {
                        root = new UnixDollar(false);
                    } else {
                        root = new Dollar(false);
                	}
                }
                return null;
            case AsciiUtil.CHAR_LOW_A:
                return AsciiUtil.CHAR_BEL;
            case AsciiUtil.CHAR_LOW_B:
                if (inclass) {
                	break;
                }
                if (create) {
                	root = new Bound(Bound.BOTH);
                }
                return null;
            case AsciiUtil.CHAR_LOW_C:
                return parseControl();
            case AsciiUtil.CHAR_LOW_D:
                if (create) {
                	root = new Posix(AsciiUtil.DIGIT);
                }
                return null;
            case AsciiUtil.CHAR_LOW_E:
                return AsciiUtil.CHAR_ESC;
            case AsciiUtil.CHAR_LOW_F:
                return AsciiUtil.CHAR_FF;
            case AsciiUtil.CHAR_LOW_G:
            case AsciiUtil.CHAR_LOW_H:
            case AsciiUtil.CHAR_LOW_I:
            case AsciiUtil.CHAR_LOW_J:
            case AsciiUtil.CHAR_LOW_K:
            case AsciiUtil.CHAR_LOW_L:
            case AsciiUtil.CHAR_LOW_M:
                break;
            case AsciiUtil.CHAR_LOW_N:
                return AsciiUtil.CHAR_LF;
            case AsciiUtil.CHAR_LOW_O:
            case AsciiUtil.CHAR_LOW_P:
            case AsciiUtil.CHAR_LOW_Q:
                break;
            case AsciiUtil.CHAR_LOW_R:
                return AsciiUtil.CHAR_CR;
            case AsciiUtil.CHAR_LOW_S:
                if (create) {
                	root = new Posix(AsciiUtil.SPACE);
                }
                return null;
            case AsciiUtil.CHAR_LOW_T:
                return AsciiUtil.CHAR_HT;
            case AsciiUtil.CHAR_LOW_U:
                return parseUnicode();
            case AsciiUtil.CHAR_LOW_V:
                return AsciiUtil.CHAR_VT;
            case AsciiUtil.CHAR_LOW_W:
                if (create) {
                	root = new Posix(AsciiUtil.WORD);
                }
                return null;
            case AsciiUtil.CHAR_LOW_X:
                return parseHexal();
            case AsciiUtil.CHAR_LOW_Y:
                break;
            case AsciiUtil.CHAR_LOW_Z:
                if (inclass) {
                	break;
                }
                if (create) {
                	root = new End();
                }
                return null;
            default:
                return ch;
        }
        throwError("Illegal/unsupported escape squence", arguments);
        return null;
    }

   private function parseClass(consume:Boolean):Node {
        var prev:Node = null;
        var node:Node = null;
        var bits:BitClass = new BitClass(false);
        var include:Boolean = true;
        var firstInClass:Boolean = true;
        var ch:Number = nextChar();
        while (true) {
            switch (ch) {
                case AsciiUtil.CHAR_CIRC:
                    // Negates if first char in a class, otherwise literal
                    if (firstInClass) {
                        if (temp[cursor-1] != AsciiUtil.CHAR_LSQB) break;
                        ch = nextChar();
                        include = !include;
                        continue;
                    } else {
                        // ^ not first in class, treat as literal
                        break;
                    }
                case AsciiUtil.CHAR_LSQB:
                    firstInClass = false;
                    node = parseClass(true);
                    if (prev == null) {
                        prev = node;
                    } else {
                        prev = new Add(prev, node);
                    }
                    ch = peekChar();
                    continue;
                case AsciiUtil.CHAR_AMP:
                    firstInClass = false;
                    ch = nextChar();
                    if (ch == AsciiUtil.CHAR_AMP) {
                        ch = nextChar();
                        var rightNode:Node = null;
                        while (ch != AsciiUtil.CHAR_RSQB && ch != AsciiUtil.CHAR_AMP) {
                            if (ch == AsciiUtil.CHAR_LSQB) {
                                if (rightNode == null) {
                                    rightNode = parseClass(true);
                                } else {
                                    rightNode = new Add(rightNode, parseClass(true));
                                }
                            } else { // abc&&def
                                unreadChar();
                                rightNode = parseClass(false);
                            }
                            ch = peekChar();
                        }
                        if (rightNode != null) {
                        	node = rightNode;
                        }
                        if (prev == null) {
                            if (rightNode == null) {
                                throwError("Bad class syntax", arguments);
                            } else {
                                prev = rightNode;
                            }
                        } else {
                            prev = new Both(prev, node);
                        }
                    } else {
                        // treat as a literal &
                        unreadChar();
                        break;
                    }
                    continue;
                case 0:
                    firstInClass = false;
                    if (cursor >= patternLength) {
                        throwError("Unclosed character class", arguments);
                    }
                    break;
                case AsciiUtil.CHAR_RSQB:
                    firstInClass = false;
                    if (prev != null) {
                        if (consume) nextChar();
                        return prev;
                    }
                    break;
                default:
                    firstInClass = false;
                    break;
            }
            node = parseRange(bits);
            if (include) {
                if (prev == null) {
                    prev = node;
                } else {
                    if (prev != node)
                    {
                        prev = new Add(prev, node);
                    }
                }
            } else {
                if (prev == null) {
                    prev = node.dup(true);  // Complement
                } else {
                    if (prev != node) {
                        prev = new Sub(prev, node);
                    }
                }
            }
            ch = peekChar();
        }
    }

    private function parseRange(bits:BitClass):Node {
        var ch:Number = peekChar();
        if (ch == AsciiUtil.CHAR_BSOL) {
            ch = nextEscapedChar();
            if (ch == AsciiUtil.CHAR_LOW_P || ch == AsciiUtil.CHAR_P) { // A property
                var comp:Boolean = (ch == AsciiUtil.CHAR_P);
                var oneLetter:Boolean = true;
                // Consume fugure bracket if present
                ch = nextChar();
                if (ch == AsciiUtil.CHAR_LCUB) {
                    unreadChar();
                } else {
                    oneLetter = false;
                }
                return parseFamily(comp, oneLetter);
            } else { // ordinary escape
                unreadChar();
                ch = parseEscape(true, true);
                if (ch == null) {
                	return root;
                }
            }
        } else {
            ch = parseSingle();
        }
        if (ch != null) {
            if (peekChar() == AsciiUtil.CHAR_MINUS) {
                var endRange:Number = temp[cursor+1];
                if (endRange == AsciiUtil.CHAR_LSQB) {
                    if (ch < 256) {
                        return bits.addChar(ch, getFlags());
                    }
                    return ceateSingle(ch);
                }
                if (endRange != AsciiUtil.CHAR_RSQB) {
                    nextChar();
                    var m:Number = parseSingle();
                    if (m < ch) {
                        throwError("Illegal character range", arguments);
                    }
                    if (hasFlag(CASE_INSENSITIVE)) {
                        return new RangeA((ch<<16)+m);
                    } else {
                        return new Range((ch<<16)+m);
                    }
                }
            }
            if (ch < 256) {
                return bits.addChar(ch, getFlags());
            }
            return ceateSingle(ch);
        }
        throwError("Unexpected character '"+chr(ch)+"'", arguments);
    }

    private function parseSingle(Void):Number {
        var ch:Number = peekChar();
        switch (ch) {
	        case AsciiUtil.CHAR_BSOL:
	            return parseEscape(true, false);
	        default:
	            nextChar();
	            return ch;
        }
    }

    private function parseFamily(flag:Boolean, singleLetter:Boolean):Node {
    	throwError("Families dosn't supported in the current Pattern's implementation", arguments);
    	return null;
    }

    private function parseGroup(Void):Node {
        var head:Node = null;
        var tail:Node = null;
        var save:Number = flags;
        root = null;
        var ch:Number = nextChar();
        if (ch == AsciiUtil.CHAR_QUEST) {
            ch = skipChar();
            switch (ch) {
            case AsciiUtil.CHAR_COLON:  //  (?:xxx) pure group
                head = createGroup(true);
                tail = root;
                head.setNext(parseExpression(tail));
                break;
            case AsciiUtil.CHAR_EQUALS:  // (?=xxx) and (?!xxx) lookahead
            case AsciiUtil.CHAR_EXCL:
                head = createGroup(true);
                tail = root;
                head.setNext(parseExpression(tail));
                if (ch == AsciiUtil.CHAR_EQUALS) {
                    head = tail = new Pos(head);
                } else {
                    head = tail = new Neg(head);
                }
                break;
            case AsciiUtil.CHAR_GT:  // (?>xxx)  independent group
                head = createGroup(true);
                tail = root;
                head.setNext(parseExpression(tail));
                head = tail = new Ques(head, INDEPENDENT);
                break;
            case AsciiUtil.CHAR_LT:  // (?<xxx)  look behind
                ch = readChar();
                head = createGroup(true);
                tail = root;
                head.setNext(parseExpression(tail));
                var info:TreeInfo = new TreeInfo();
                head.study(info);
                if (info.maxValid == false) {
                    throwError("Look-behind group does not have an obvious maximum length", arguments);
                }
                if (ch == AsciiUtil.CHAR_EQUALS) {
                    head = tail = new Behind(head, info.maxLength, info.minLength);
                } else if (ch == AsciiUtil.CHAR_EXCL) {
                    head = tail = new NotBehind(head, info.maxLength, info.minLength);
                } else {
                    throwError("Unknown look-behind group", arguments);
                }
                break;
            case AsciiUtil.CHAR_1:case AsciiUtil.CHAR_2:case AsciiUtil.CHAR_3:case AsciiUtil.CHAR_4:case AsciiUtil.CHAR_5:
            case AsciiUtil.CHAR_6:case AsciiUtil.CHAR_7:case AsciiUtil.CHAR_8:case AsciiUtil.CHAR_9:
                if (groupNodes[ch - AsciiUtil.CHAR_0] != null) {
                    head = tail = new GroupRef(groupNodes[ch - AsciiUtil.CHAR_0]);
                    break;
                }
                throwError("Unknown group reference", arguments);
            case AsciiUtil.CHAR_DOLLAR:
            case AsciiUtil.CHAR_COMMAT:
				throwError("Unknown group type", arguments);
            default:   // (?xxx:) inlined match flags
                unreadChar();
                addFlag();
                ch = readChar();
                if (ch == AsciiUtil.CHAR_RPAR) {
                    return null;    // Inline modifier only
                }
                if (ch != AsciiUtil.CHAR_COLON) {
                    throwError("Unknown inline modifier", arguments);
                }
                head = createGroup(true);
                tail = root;
                head.setNext(parseExpression(tail));
                break;
            }
        } else { // (xxx) a regular group
            head = createGroup(false);
            tail = root;
            head.setNext(parseExpression(tail));
        }

        acceptChar(AsciiUtil.CHAR_RPAR, "Unclosed group");
        flags = save;

        // Check for quantifiers
        var node:Node = parseClosure(head);
        if (node == head) { // No closure
            root = tail;
            return node;    // Dual return
        }
        if (head == tail) { // Zero length assertion
            root = node;
            return node;    // Dual return
        }

        if (node instanceof Ques) {
            var ques:Ques = Ques(node);
            if (ques.getType() == POSSESSIVE) {
                root = node;
                return node;
            }
            // Dummy node to connect branch
            tail.setNext(new Dummy());
            tail = tail.getNext();
            if (ques.getType() == GREEDY) {
                head = new Branch(head, tail);
            } else { 
            	// Reluctant quantifier
                head = new Branch(tail, head);
            }
            root = tail;
            return head;
        } else if (node instanceof Curly) {
            var curly:Curly = Curly(node);
            if (curly.getType() == POSSESSIVE) {
                root = node;
                return node;
            }
            // Discover if the group is deterministic
            var info:TreeInfo = new TreeInfo();
            if (head.study(info)) { 
            	// Deterministic
                var temp:GroupTail = GroupTail(tail);
                head = root = new GroupCurly(head.getNext(), curly.getCmin(),
                                   curly.getCmax(), curly.getType(),
                                   (GroupTail(tail)).getLocalIndex(),
                                   (GroupTail(tail)).getGroupIndex());
                return head;
            } else { 
            	// Non-deterministic
                var tmp:Number = (GroupHead(head)).getLocalIndex();
                var loop:Loop;
                if (curly.getType() == GREEDY) {
                    loop = new Loop(this.localCount, tmp);
                } else { 
                	// Reluctant Curly
                    loop = new LazyLoop(this.localCount, tmp);
                }
                var prolog:Prolog = new Prolog(loop);
                localCount += 1;
                loop.setCmin(curly.getCmin());
                loop.setCmax(curly.getCmax());
                loop.setBody(head);
                tail.setNext(loop);
                root = loop;
                return prolog; // Dual return
            }
        } else if (node instanceof First) {
            root = node;
            return node;
        }
        throwError("Internal logic error", arguments);
    }

    private function createGroup(anonymous:Boolean):Node {
        var localIndex:Number = localCount++;
        var groupIndex:Number = 0;
        if (!anonymous) {
            groupIndex = groupCount++;
        }
        var head:GroupHead = new GroupHead(localIndex);
        root = new GroupTail(localIndex, groupIndex);
        if (!anonymous && groupIndex < 10) {
            groupNodes[groupIndex] = head;
        }
        return head;
    }

    private function addFlag(Void):Void {
        var ch:Number = peekChar();
        while (true) {
            switch (ch) {
            case AsciiUtil.CHAR_LOW_I:
                flags |= CASE_INSENSITIVE;
                break;
            case AsciiUtil.CHAR_LOW_M:
                flags |= MULTILINE;
                break;
            case AsciiUtil.CHAR_LOW_S:
                flags |= DOTALL;
                break;
            case AsciiUtil.CHAR_LOW_D:
                flags |= UNIX_LINES;
                break;
            case AsciiUtil.CHAR_LOW_U:
                flags |= UNICODE_CASE;
                break;
            case AsciiUtil.CHAR_LOW_X:
                flags |= COMMENTS;
                break;
            case AsciiUtil.CHAR_MINUS: // subFlag then fall through
                ch = nextChar();
                subFlag();
            default:
                return;
            }
            ch = nextChar();
        }
    }

    private function subFlag(Void):Void {
        var ch:Number = peekChar();
        while (true) {
            switch (ch) {
            case AsciiUtil.CHAR_LOW_I:
                flags &= ~CASE_INSENSITIVE;
                break;
            case AsciiUtil.CHAR_LOW_M:
                flags &= ~MULTILINE;
                break;
            case AsciiUtil.CHAR_LOW_S:
                flags &= ~DOTALL;
                break;
            case AsciiUtil.CHAR_LOW_D:
                flags &= ~UNIX_LINES;
                break;
            case AsciiUtil.CHAR_LOW_U:
                flags &= ~UNICODE_CASE;
                break;
            case AsciiUtil.CHAR_LOW_X:
                flags &= ~COMMENTS;
                break;
            default:
                return;
            }
            ch = nextChar();
        }
    }

    private static var MAX_REPS:Number	= 0x7FFFFFFF;

    public static var GREEDY:Number			= 0;
    public static var LAZY:Number			= 1;
    public static var POSSESSIVE:Number 	= 2;
    public static var INDEPENDENT:Number 	= 3;

	public static var ACCEPT:Node;
    public static var LASTACCEPT:Node;
	

    private function parseClosure(prev:Node):Node {
        var atom:Node;
        var ch:Number = peekChar();
        switch (ch) {
        case AsciiUtil.CHAR_QUEST:
            ch = nextChar();
            if (ch == AsciiUtil.CHAR_QUEST) {
                nextChar();
                return new Ques(prev, LAZY);
            } else if (ch == AsciiUtil.CHAR_PLUS) {
                nextChar();
                return new Ques(prev, POSSESSIVE);
            }
            return new Ques(prev, GREEDY);
        case AsciiUtil.CHAR_AST:
            ch = nextChar();
            if (ch == AsciiUtil.CHAR_QUEST) {
                nextChar();
                return new Curly(prev, 0, MAX_REPS, LAZY);
            } else if (ch == AsciiUtil.CHAR_PLUS) {
                nextChar();
                return new Curly(prev, 0, MAX_REPS, POSSESSIVE);
            }
            return new Curly(prev, 0, MAX_REPS, GREEDY);
        case AsciiUtil.CHAR_PLUS:
            ch = nextChar();
            if (ch == AsciiUtil.CHAR_QUEST) {
                nextChar();
                return new Curly(prev, 1, MAX_REPS, LAZY);
            } else if (ch == AsciiUtil.CHAR_PLUS) {
                nextChar();
                return new Curly(prev, 1, MAX_REPS, POSSESSIVE);
            }
            return new Curly(prev, 1, MAX_REPS, GREEDY);
        case AsciiUtil.CHAR_LCUB:
            ch = temp[cursor+1];
            if (AsciiUtil.isDigit(ch)) {
                skipChar();
                var cmin:Number = 0;
                do {
                    cmin = cmin * 10 + (ch - AsciiUtil.CHAR_0);
                } while (AsciiUtil.isDigit((ch = readChar())));
                var cmax:Number = cmin;
                if (ch == AsciiUtil.CHAR_COMMA) {
                    ch = readChar();
                    cmax = MAX_REPS;
                    if (ch != AsciiUtil.CHAR_RCUB) {
                        cmax = 0;
                        while (AsciiUtil.isDigit(ch)) {
                            cmax = cmax * 10 + (ch - AsciiUtil.CHAR_0);
                            ch = readChar();
                        }
                    }
                }
                if (ch != AsciiUtil.CHAR_RCUB) {
                    throwError("Unclosed counted closure", arguments);
                }
                if (((cmin) | (cmax) | (cmax - cmin)) < 0) {
                    throwError("Illegal repetition range", arguments);
                }
                var curly:Curly;
                ch = peekChar();
                if (ch == AsciiUtil.CHAR_QUEST) {
                    nextChar();
                    curly = new Curly(prev, cmin, cmax, LAZY);
                } else if (ch == AsciiUtil.CHAR_PLUS) {
                    nextChar();
                    curly = new Curly(prev, cmin, cmax, POSSESSIVE);
                } else {
                    curly = new Curly(prev, cmin, cmax, GREEDY);
                }
                return curly;
            } else {
                throwError("Illegal repetition", arguments);
            }
            return prev;
        default:
            return prev;
        }
    }

    private function parseControl(Void):Number {
        if (cursor < patternLength) {
            return (readChar() ^ 64);
        }
        throwError("Illegal control escape sequence", arguments);
        return null;
    }

    /**
     *  Utility method for parsing octal escape sequences.
     */
    private function parseOctal(Void):Number {
        var n:Number = readChar();
        if (((n - AsciiUtil.CHAR_0) | (AsciiUtil.CHAR_7 - n)) >= 0) {
            var m:Number = readChar();
            if (((m - AsciiUtil.CHAR_0) | (AsciiUtil.CHAR_7 - m)) >= 0) {
                var o:Number = readChar();
                if ((((o - AsciiUtil.CHAR_0) | (AsciiUtil.CHAR_7 - o)) >= 0) && (((n - AsciiUtil.CHAR_0) | (AsciiUtil.CHAR_3 - n)) >= 0)) {
                    return (n - AsciiUtil.CHAR_0) * 64 + (m - AsciiUtil.CHAR_0) * 8 + (o - AsciiUtil.CHAR_0);
                }
                unreadChar();
                return (n - AsciiUtil.CHAR_0) * 8 + (m - AsciiUtil.CHAR_0);
            }
            unreadChar();
            return (n - AsciiUtil.CHAR_0);
        }
        throwError("Illegal octal escape sequence", arguments);
        return null;
    }

    private function parseHexal(Void):Number {
        var n:Number = readChar();
        if (AsciiUtil.isHexDigit(n)) {
            var m:Number = readChar();
            if (AsciiUtil.isHexDigit(m)) {
                return AsciiUtil.toDigit(n) * 16 + AsciiUtil.toDigit(m);
            }
        }
        throwError("Illegal hexadecimal escape sequence", arguments);
        return null;
    }

    private function parseUnicode(Void):Number {
        var n:Number = 0;
        for (var i = 0; i < 4; i++) {
            var ch:Number = readChar();
            if (!AsciiUtil.isHexDigit(ch)) {
                throwError("Illegal Unicode escape sequence", arguments);
            }
            n = n * 16 + AsciiUtil.toDigit(ch);
        }
        return n;
    }

    private function ceateSingle(ch:Number):Node {
        var f:Number = flags;
        if ((f & CASE_INSENSITIVE) == 0) {
            return new Single(ch);
        }
        if ((f & UNICODE_CASE) == 0) {
            return new SingleA(ch);
        }
        return new SingleU(ch);
    }

    private function createSlice(buf:Array, count:Number, hasSupplementary:Boolean):Node {
        var tmp:Array = new Array(count); 
        var i:Number = flags;
        if ((i & CASE_INSENSITIVE) == 0) {
            for (i = 0; i < count; i++) {
                tmp[i] = buf[i];
            }
            return new Slice(tmp);
        } else if ((i & UNICODE_CASE) == 0) {
            for (i = 0; i < count; i++) {
                tmp[i] = AsciiUtil.toLower(buf[i]);
            }
            return new SliceA(tmp);
        } else {
            for (i = 0; i < count; i++) {
                var c:Number = buf[i];
                c = AsciiUtil.toLower(AsciiUtil.toUpper(c));
                tmp[i] = c;
            }
            return new SliceU(tmp);
        }
    }

	private function toCharCodeArray(source:String):Array {
		var charCodeArray:Array = new Array(source.length);
		for (var i = 0; i < source.length; i++) {
			charCodeArray[i] = source.charCodeAt(i);
		}	
		return charCodeArray;
	}
	
	private function fromCharCodeArray(source:Array):String {
		var str:String = new String();
		for (var i = 0; i < source.length; i++) {
			str += String.fromCharCode(source[i]);
		}	
		return str;
	}

}
