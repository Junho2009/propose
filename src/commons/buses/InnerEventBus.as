package commons.buses
{
    import flash.errors.IllegalOperationError;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    
    /**
     * 内部事件总线
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public class InnerEventBus extends EventDispatcher
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:InnerEventBus = null;
        
        
        public function InnerEventBus(target:IEventDispatcher=null)
        {
            if(!_allowInstance)
                throw new IllegalOperationError("InnerEventBus is a singleton class.");
        }
        
        public static function getInstance():InnerEventBus
        {
            if (null == _instance)
            {
                _allowInstance = true;
                _instance = new InnerEventBus();
                _allowInstance = false;
            }
            return _instance;
        }
    }
}