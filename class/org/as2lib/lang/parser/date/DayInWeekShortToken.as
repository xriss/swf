import org.as2lib.lang.parser.date.DateToken;
import org.as2lib.util.DateTokenFactory;

/**
 * @author MartinHeidegger
 */
class org.as2lib.lang.parser.date.DayInWeekShortToken extends DateToken {
	
	public function DayInWeekShortToken(Void) {
		super(DateTokenFactory.DAY_IN_WEEK_SHORT_FIELD, []);
	}
	
	public function getText(attributes:Array):String {
		return getDate(attributes).getDay().toString();
	}
}