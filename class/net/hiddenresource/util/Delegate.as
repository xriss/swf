/*
 * Delegate.as v1.0.1 (MTASC compatible)
 */
class net.hiddenresource.util.Delegate
{
	public static function create(target:Object, handler:Function):Function
	{
		// Get any extra arguments for handler
		var extraArgs:Array = arguments.slice(2);
		
		// Declare delegate variable (MTASC compatibility)
		var delegate:Function;
		
		// Create delegate function
		delegate = function():Object
		{
			// Augment arguments passed from broadcaster with additional args
			var fullArgs:Array = arguments.concat(extraArgs, [delegate]);
			
			// Call handler with arguments
			return handler.apply(target, fullArgs);
		};
		
		// Return the delegate function.
		return delegate;
	}
}
