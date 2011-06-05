import org.as2lib.lang.parser.date.DateToken;
import org.as2lib.util.DateTokenFactory;

/**
 * @author MartinHeidegger
 */
class org.as2lib.lang.parser.date.DayInMonthToken extends DateToken {
	
	public function DayInMonthToken(Void) {
		super(DateTokenFactory.DAY_IN_MONTH_FIELD, []);
	}
	
	public function getText(attributes:Array):String {
		return getDate(attributes).getUTCDate().toString();
	}
}