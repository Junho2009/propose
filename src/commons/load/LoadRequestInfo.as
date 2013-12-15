package commons.load
{
    import flash.errors.IllegalOperationError;

    /**
     * 加载请求信息
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public class LoadRequestInfo
    {
        /**
         * 请求加载单个文件时使用的url
         */        
        public var url:String = "";
        private var _trimUrl:String = "";
        
        /**
         * 请求加载多个文件时使用的url列表
         */        
        public var urlList:Vector.<String> = null;
        
        public var token:String = "";
        
        public var callback:Function = null;
        public var callbackData:Object = null;
        public var failCallback:Function = null;
        public var failCallbackData:Object = null;
        
        /**
         * 请求单个文件时使用的url（去除了根路径）
         * @return String
         * 
         */        
        public function get trimUrl():String
        {
            if ("" == url)
                throw new IllegalOperationError("未指定url");
            
            if ("" == _trimUrl)
                _trimUrl = FilePath.trimRoot(url);
            return _trimUrl;
        }
        
        public function dispose():void
        {
            url = "";
            _trimUrl = "";
            
            if (null != urlList)
            {
                urlList.length = 0;
                urlList = null;
            }
            
            token = "";
            
            callback = null;
            callbackData = null;
            failCallback = null;
            failCallbackData = null;
        }
    }
}