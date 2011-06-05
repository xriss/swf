import org.as2lib.lang.parser.date.DateToken;
import org.as2lib.util.DateTokenFactory;

/**
 * @author MartinHeidegger
 */
class org.as2lib.lang.parser.date.YearToken extends DateToken {
	
	public function YearToken() {
		super(DateTokenFactory.YEAR_FIELD, []);
	}

	public function getText(attributes:Array):String {
		return getDate(attributes).getFullYear().toString();
	}
}