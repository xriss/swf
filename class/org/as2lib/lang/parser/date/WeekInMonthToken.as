import org.as2lib.lang.parser.date.DateToken;
import org.as2lib.util.DateTokenFactory;

/**
 * @author MartinHeidegger
 */
class org.as2lib.lang.parser.date.WeekInMonthToken extends DateToken {
	
	public function WeekInMonthToken(Void) {
		super(DateTokenFactory.WEEK_IN_MONTH_FIELD, []);
	}
	
	public function getText(attributes:Array):String {
		return (Math.floor(getDate(attributes).getUTCDate()/7)+1).toString();
	}
}