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
        private var _urlList:Vector.<String> = null;
        private var _totalFileNum:uint = 0;
        
        public var token:String = "";
        
        public var completedCallback:Function = null;
        public var completedCallbackData:Object = null;
        public var failCallback:Function = null;
        public var failCallbackData:Object = null;
        public var singleCompCallback:Function = null;
        
        public var isNeetToRetry:Boolean = true;
        
        /**
         * 扩展数据
         */        
        public var param:Object = null;
        
        
        
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
        
        public function set urlList(value:Vector.<String>):void
        {
            if (null == value || 0 == value.length)
                return;
            
            _urlList = value;
            _totalFileNum = value.length;
        }
        
        public function get urlList():Vector.<String>
        {
            return _urlList;
        }
        
        public function get totalFileNum():uint
        {
            return _totalFileNum;
        }
        
        public function clone():LoadRequestInfo
        {
            var req:LoadRequestInfo = new LoadRequestInfo();
            
            req.url = this.url;
            req.urlList = this.urlList;
            req.token = this.token;
            req.completedCallback = this.completedCallback;
            req.completedCallbackData = this.completedCallbackData;
            req.failCallback = this.failCallback;
            req.failCallbackData = this.failCallbackData;
            req.singleCompCallback = this.singleCompCallback;
            req.isNeetToRetry = this.isNeetToRetry;
            req.param = this.param;
            
            return req;
        }
        
        public function dispose():void
        {
            url = "";
            _trimUrl = "";
            
            if (null != _urlList)
            {
                _urlList.length = 0;
                _urlList = null;
            }
            
            token = "";
            
            completedCallback = null;
            completedCallbackData = null;
            failCallback = null;
            failCallbackData = null;
        }
    }
}