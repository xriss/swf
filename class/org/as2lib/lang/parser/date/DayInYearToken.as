import org.as2lib.lang.parser.date.DateToken;
import org.as2lib.util.DateTokenFactory;

/**
 * @author MartinHeidegger
 */
class org.as2lib.lang.parser.date.DayInYearToken extends DateToken {
	
	private static var DAYS_IN_MONTHS:Array = [31,28,31,30,31,30,31,31,30,31,30,31];
	
	public static function getDaysInYear(date:Date):Number {
		var result:Number = 0;
		var months:Number = date.getUTCMonth();
		for (var i=0; i < months; i++) {
			result += DAYS_IN_MONTHS[i];
		}
		return result;
	}
	
	public function DayInYearToken(Void) {
		super(DateTokenFactory.DAY_IN_YEAR_FIELD, []);
	}
	
	public function getText(attributes:Array):String {
		return getDate(attributes).getUTCDate().toString();
	}
}