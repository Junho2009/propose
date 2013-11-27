package commons.singleton
{
    import flash.errors.IllegalOperationError;

    /**
     * 全局配置
     * @author Junho
     * <br/>Create: 2013.11.27
     */    
    public final class GlobalConfig
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:GlobalConfig = null;
        
        private var _serverAddr:String = null;
        private var _serverPort:uint = 0;
        
        
        public function GlobalConfig()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("GlobalConfig is a singleton class.");
        }
        
        /**
         * 获取当前实例 
         * @return GlobalConfig
         * 
         */	
        public static function getInstance():GlobalConfig
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new GlobalConfig();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        
        
        public function get serverAddr():String
        {
            return _serverAddr;
        }
        
        public function set serverAddr(value:String):void
        {
            _serverAddr = value;
        }
        
        public function get serverPort():uint
        {
            return _serverPort;
        }
        
        public function set serverPort(value:uint):void
        {
            _serverPort = value;
        }
    }
}