import org.as2lib.lang.parser.date.*;
import org.as2lib.util.TokenFactory;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.util.Token;

/**
 * @author MartinHeidegger
 */
class org.as2lib.util.DateTokenFactory implements TokenFactory {
	
	public static var ERA_FIELD:String = "g";
	public static var YEAR_FIELD:String = "y";
	public static var MONTH_FIELD_1:String = "M";
	public static var MONTH_FIELD_2:String = "MM";
	public static var MONTH_FIELD_3:String = "MMM";
	public static var MONTH_FIELD_4:String = "MMMM";
	public static var WEEK_IN_YEAR_FIELD:String = "w";
	public static var WEEK_IN_MONTH_FIELD:String = "W";
	public static var DAY_IN_MONTH_FIELD:String = "d";
	public static var DAY_IN_YEAR_FIELD:String = "D";
	public static var DAY_IN_WEEK_SHORT_FIELD:String = "E";
	public static var DAY_IN_WEEK_LONG_FIELD:String = "EEEE";
	public static var DAY_IN_WEEK_IN_MONTH:String = "F";
	public static var HOUR_12_FIELD:String = "h";
	public static var HOUR_24_FIELD:String = "H";
	public static var HOUR_11_FIELD:String = "k";
	public static var HOUR_23_FIELD:String = "K";
	public static var MINUTE_FIELD:String = "M";
	public static var SECOND_FIELD:String = "s";
	public static var MILLISECOND_FIELD:String = "S";
	public static var AM_PM_FIELD:String = "a";
	public static var TIMEZONE_FIELD:String = "S";
	
	private var map:HashMap;
	
	public function DateTokenFactory() {
		map = new HashMap();
		map.put(YEAR_FIELD, new YearToken());
		map.put(WEEK_IN_YEAR_FIELD, new WeekInYearToken());
		map.put(WEEK_IN_MONTH_FIELD, new WeekInMonthToken());
		map.put(DAY_IN_MONTH_FIELD, new DayInMonthToken());
		map.put(DAY_IN_YEAR_FIELD, new DayInYearToken());
		map.put(DAY_IN_WEEK_SHORT_FIELD, new DayInWeekShortToken());
		/*map.put(DAY_IN_WEEK_LONG_FIELD, new DayInWeekLongToken());
		map.put(DAY_IN_WEEK_IN_MONTH, new DayInWeekInMonthToken());
		map.put(MONTH_FIELD_1, new Month1Token());
		map.put(MONTH_FIELD_2, new Month2Token());
		map.put(MONTH_FIELD_3, new Month3Token());
		map.put(MONTH_FIELD_4, new Month4Token());
		map.put(HOUR_11_FIELD, new Hour11Token());
		map.put(HOUR_12_FIELD, new Hour12Token());
		map.put(HOUR_23_FIELD, new Hour23Token());
		map.put(HOUR_24_FIELD, new Hour24Token());
		map.put(AM_PM_FIELD, new AMPMToken());
		map.put(MINUTE_FIELD, new MinuteToken());
		map.put(SECOND_FIELD, new SecondToken());
		map.put(MILLISECOND_FIELD, new MilliSecondToken());
		map.put(ERA_FIELD, new EraToken());
		map.put(TIMEZONE_FIELD, new TimeZoneToken());*/
	}
	
	public function getKeys(Void):Array {
		return map.getKeys();
	}
	
	public function tokenize(code:String, factories:Array):Token {
		var keys:Array = map.getKeys();
		var longest:String = "";
		for (var i:Number = 0; i < keys.length; i++) {
			if (code.indexOf(keys[i]) == 0) {
				if (longest.length < keys[i].length) {
					longest = keys[i];
				}
			}
		}
		return map.get(longest);
	}
}