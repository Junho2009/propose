package commons.load
{
    import flash.events.Event;
    
    /**
     * 加载器相关事件
     * @author junho
     * <br/>Create: 2013.12.14
     */    
    public class MyLoaderEvent extends Event
    {
        /**
         * 加载进度通知
         */        
        public static const PROGRESS:String = "MyLoaderEvent.PROGRESS";
        
        /**
         * 加载完毕
         */        
        public static const COMPLETE:String = "MyLoaderEvent.COMPLETE";
        
        /**
         * 加载失败
         */        
        public static const FAILED:String = "MyLoaderEvent.FAILED";
        
        
        private var _url:String;
        private var _data:Object;
        
        
        public function MyLoaderEvent(type:String, url:String, data:Object = null)
        {
            super(type);
            _url = url;
            _data = data;
        }
        
        public function get url():String
        {
            return _url;
        }
        
        public function get data():Object
        {
            return _data;
        }
    }
}