package commons.load
{
    /**
     * 加载请求信息
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public class LoadRequestInfo
    {
        public var trimUrl:String = "";
        public var token:String = "";
        
        public var callback:Function = null;
        public var callbackData:Object = null;
        public var failCallback:Function = null;
        public var failCallbackData:Object = null;
        
        public function dispose():void
        {
            trimUrl = "";
            token = "";
            callback = null;
            callbackData = null;
            failCallback = null;
            failCallbackData = null;
        }
    }
}