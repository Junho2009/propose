package commons.manager.base
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;

    /**
     * 管理器中心
     * @author Junho
     * <br/>Create: 2013.11.30
     */    
    public final class ManagerHub
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:ManagerHub = null;
        
        private var _mgrDic:Dictionary;
        
        
        public function ManagerHub()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("ManagerHub is a singleton class.");
            
            _mgrDic = new Dictionary();
        }
        
        /**
         * 获取当前实例 
         * @return ManagerHub
         * 
         */	
        public static function getInstance():ManagerHub
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new ManagerHub();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        
        
        public function getManager(name:String):IManager
        {
            return _mgrDic[name];
        }
        
        public function register(name:String, manager:IManager):void
        {
            _mgrDic[name] = manager;
        }
        
        public function unregister(name:String):void
        {
            if (null != _mgrDic[name])
            {
                _mgrDic[name] = null;
                delete _mgrDic[name];
            }
        }
    }
}