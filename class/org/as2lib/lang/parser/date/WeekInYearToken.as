import org.as2lib.lang.parser.date.DateToken;
import org.as2lib.util.DateTokenFactory;
import org.as2lib.lang.parser.date.DayInYearToken;

/**
 * @author MartinHeidegger
 */
class org.as2lib.lang.parser.date.WeekInYearToken extends DateToken {
	
	
	public function WeekInYearToken(Void) {
		super(DateTokenFactory.WEEK_IN_YEAR_FIELD, []);
	}
	
	public function getText(attributes:Array):String {
		return (Math.floor(DayInYearToken.getDaysInYear(getDate(attributes))/7)+1).toString();
	}
}