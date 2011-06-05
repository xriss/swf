import org.as2lib.data.holder.AbstractPriority;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.list.SubList;
import org.as2lib.env.overload.Overload;
import org.as2lib.data.holder.Iterator;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.list.PriorityList extends AbstractPriority implements List {
	private var list:List;
	private var priorityArray:Array;
	
	public function PriorityList(list:List) {
		this.list = list;
		priorityArray = new Array();
		if (!list.isEmpty()) {
			var iterator:Iterator = list.iterator();
			while (iterator.hasNext()) {
				priorityArray.push(PRIORITY_NORMAL);
			}
		}
	}
	
	public function insert():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Object], insertByValue);
		o.addHandler([Object, Number], insertByValueAndPriority);
		o.forward(arguments);
	}
	
	public function insertByValue(value):Void {
		insertByValueAndPriority(value, PRIORITY_NORMAL);
	}
	
	public function insertByValueAndPriority(value, priority:Number):Void {
		list.insertLast(value);
		filterUp(priorityArray.push(priority) - 1);
	}
	
	private function filterUp(index:Number):Void {
		if (index > 0) {
			for (var i:Number = index; i > 0 && (priorityArray[i-1] > priorityArray[i]); i--) {
				var parent:Number = i - 1;
				var priority:Number = priorityArray[i];
				priorityArray[i] = priorityArray[parent];
				priorityArray[parent] = priority;
				var value = list.get(i);
				list.set(i, list.get(parent));
				list.set(parent, value);
			}
		}
	}
	
	public function insertFirst(value):Void {
		insertByValueAndPriority(value, isNaN(priorityArray[0] - 1) ? PRIORITY_NORMAL : priorityArray[0] - 1);
	}
	
	public function insertLast(value):Void {
		insertByValueAndPriority(value, isNaN(priorityArray[priorityArray.length-1] - 1) ? PRIORITY_NORMAL : priorityArray[priorityArray.length-1] - 1);
	}
	
	public function insertAll():Void {
		var o:Overload = new Overload(this);
		o.addHandler([List], insertAllByList);
		o.addHandler([List, Number], insertAllByListAndPriority);
		o.forward(arguments);
	}
	
	public function insertAllByList(list:List):Void {
		insertAllByListAndPriority(list, PRIORITY_NORMAL);
	}
	
	public function insertAllByListAndPriority(list:List, priority:Number):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			insertByValueAndPriority(iterator.next(), priority);
		}
	}
	
	public function remove() {
		var o:Overload = new Overload(this);
		o.addHandler([Object], removeByValue);
		o.addHandler([Number], removeByIndex);
		return o.forward(arguments);
	}
	
	public function removeByValue(value):Number {
		var i:Number = indexOf(value);
		removeByIndex(i);
		return i;
	}
	
	public function removeByIndex(index:Number) {
		priorityArray.splice(index, 1);
		return list.removeByIndex(index);
	}
	
	public function removeFirst(Void) {
		priorityArray.shift();
		return list.removeFirst();
	}
	
	public function removeLast(Void) {
		priorityArray.pop();
		return list.removeLast();
	}
	
	public function removeAll(list:List):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			removeByValue(iterator.next());
		}
	}
	
	public function set(index:Number, value) {
		if (!list.get(index)) {
			priorityArray[index] = priorityArray[getLeft()];
		}
		return list.set(index, value);
	}
	
	public function setAll(index:Number, list:List):Void {
		var iterator:Iterator = list.iterator();
		while (iterator.hasNext()) {
			this.set(index++, iterator.next());
		}
	}
	
	public function get(index:Number) {
		return list.get(index);
	}
	
	public function contains(value):Boolean {
		return list.contains(value);
	}
	
	public function containsAll(list:List):Boolean {
		return this.list.containsAll(list);
	}
	
	public function retainAll(list:List):Void {
		for (var i:Number = 0; i < priorityArray.length; i++) {
			if (!list.contains(this.list.get(i))) {
				removeByIndex(i--);
			}
		}
	}
	
	public function subList(fromIndex:Number, toIndex:Number):List {
		return new SubList(this, fromIndex, toIndex);
	}
	
	public function clear(Void):Void {
		priorityArray = new Array();
		list.clear();
	}
	
	public function size(Void):Number {
		return list.size();
	}
	
	public function isEmpty(Void):Boolean {
		return list.isEmpty();
	}
	
	public function iterator(Void):Iterator {
		return list.iterator();
	}
	
	public function indexOf(value):Number {
		return list.indexOf(value);
	}
	
	public function changePriority():Void {
		var o:Overload = new Overload(this);
		o.addHandler([Object, Number, Boolean], changePriorityByValue);
		o.addHandler([Number, Number, Boolean], changePriorityByIndex);
		o.forward(arguments);
	}
	
	public function changePriorityByValue(value, priority:Number, absolute:Boolean):Void {
		changePriorityByIndex(indexOf(value), priority, absolute);
	}
	
	public function changePriorityByIndex(index:Number, priority:Number, absolute:Boolean):Void {
		var oldPriority:Number = priorityArray[index];
		if (absolute) {
			priorityArray[index] = priority;
		} else {
			priorityArray[index] += priority;
		}
		if (oldPriority > priorityArray[index]) {
			filterUp(index);
		} else {
			filterDown(index);
		}
	}
	
	private function filterDown(index:Number):Void {
		var done:Boolean = false;
		var i:Number = index;
		var largest:Number;
		do {
			largest = i;
			if (hasLeft(i) && priorityArray[i] > priorityArray[getLeft(i)]) {
				largest = getLeft(i);
			}
			if (hasRight(i) && priorityArray[largest] > priorityArray[getRight(i)]) {
				largest = getRight(i);
			}
			if (largest != i) {
				var value = list.get(i);
				list.set(i, list.get(largest));
				list.set(largest, value);
				var priority:Number = priorityArray[i];
				priorityArray[i] = priorityArray[largest];
				priorityArray[largest] = priority;
				i = largest;
			} else {
				done = true;
			}
		} while (!done);
	}
	
	private function hasLeft(index:Number):Boolean {
		return ((2 * index + 1) < priorityArray.length);
	}
	
	private function hasRight(index:Number):Boolean {
		return ((2 * index + 2) < priorityArray.length);
	}
	
	private function getLeft(index:Number):Number {
		return (2 * index + 1);
	}
	
	private function getRight(index:Number):Number {
		return (2 * index + 2);
	}
	
	public function toArray(Void):Array {
		return list.toArray();
	}
	
	public function toString():String {
		return list.toString();
	}
	
	public function insertAllByIndexAndList(index:Number, list:List):Void {
	}

	public function insertByIndexAndValue(index:Number, value):Void {
	}

}