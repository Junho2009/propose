package commons.cache
{
    import flash.utils.Dictionary;
    
    import commons.manager.ICacheManager;
    
    /**
     * 缓存管理器
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public class CacheManager implements ICacheManager
    {
//        private var _so:SharedObject;暂时没用本地缓存对象
        private var _dataDic:Dictionary;
        
        
        public function CacheManager()
        {
            _dataDic = new Dictionary();
        }
        
        public function addData(data:*, key:String, version:String=null):void
        {
            _dataDic[genKey(key, version)] = data;
        }
        
        public function getData(key:String, version:String=null):*
        {
            return _dataDic[genKey(key, version)];
        }
        
        public function remove(key:String, version:String=null):void
        {
            var key:String = genKey(key, version);
            if (null != _dataDic[key])
            {
                _dataDic[key] = null;
                delete _dataDic[key];
            }
        }
        
        
        
        private function genKey(key:String, version:String=null):String
        {
            if (null == version)
                return key;
            else
                return key + "-" + version;
        }
    }
}