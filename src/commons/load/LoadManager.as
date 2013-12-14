package commons.load
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;

    /**
     * 加载管理器
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public class LoadManager implements ILoadManager
    {
        private static const _MAX_MULTI_LOAD_NUM:uint = 5; // 最多同时进行的加载请求数
        
        private var _loaderPool:Vector.<MyLoader>;
        
        private var _reqListDic:Dictionary; // url字典，每个key为去掉根路径后的url、每个值为对应的加载请求列表
        private var _runningLoaderDic:Dictionary; // 加载中的loaders
        private var _waitingReqList:Vector.<LoadRequestInfo>; // 等待中的加载请求列表
        
        private var _usingTokenDic:Dictionary; // 正在使用的加载请求令牌
        
        
        public function LoadManager()
        {
            var i:int = 0;
            
            _loaderPool = new Vector.<MyLoader>();
            for (i = 0; i < _MAX_MULTI_LOAD_NUM; ++i)
            {
                _loaderPool.push(createLoader());
            }
            
            _reqListDic = new Dictionary();
            _runningLoaderDic = new Dictionary();
            _waitingReqList = new Vector.<LoadRequestInfo>();
            _usingTokenDic = new Dictionary();
        }
        
        public function isLoading(url:String):Boolean
        {
            return (null != _runningLoaderDic[FilePath.trimRoot(url)]);
        }
        
        public function load(url:String, info:LoadRequestInfo):void
        {
            if (null == url || "" == url)
                throw new IllegalOperationError("请求加载的url为空字符串");
            
            info.trimUrl = FilePath.trimRoot(url);
            
            var loader:MyLoader = null;
            var reqList:Vector.<LoadRequestInfo> = null;
            
            if (!isLoading(url))
            {
                loader = reqLoader();
                if (null != loader)
                {
                    reqList = new Vector.<LoadRequestInfo>();
                    _reqListDic[info.trimUrl] = reqList;
                    reqList.push(info);
                    info.token = genToken();
                    
                    loader.load(url);
                }
                else
                {
                    _waitingReqList.push(info);
                }
            }
            else
            {
                reqList = _reqListDic[info.trimUrl] as Vector.<LoadRequestInfo>;
                reqList.push(info);
                info.token = genToken();
            }
        }
        
        public function stopLoad(token:String):void
        {
        }
        
        public function isLoadingList(urlList:Array):void
        {
        }
        
        public function loadList(urlList:Array, info:LoadRequestInfo):void
        {
        }
        
        public function stopLoadList(token:String):void
        {
        }
        
        
        
        private function reqLoader():MyLoader
        {
            if (_loaderPool.length > 1)
                return _loaderPool.shift();
            else
                return null;
        }
        
        private function createLoader():MyLoader
        {
            var loader:MyLoader = new MyLoader();
            loader.addEventListener(MyLoaderEvent.COMPLETE, onLoadCompleted);
            loader.addEventListener(MyLoaderEvent.FAILED, onLoadFailed);
            loader.addEventListener(MyLoaderEvent.PROGRESS, onLoadProgress);
            return loader;
        }
        
        private function onLoadCompleted(e:MyLoaderEvent):void
        {
            var trimUrl:String = FilePath.trimRoot(e.url);
            var reqList:Vector.<LoadRequestInfo> = _reqListDic[trimUrl] as Vector.<LoadRequestInfo>;
            var i:int = 0;
            var reqInfo:LoadRequestInfo = null;
            const reqListLen:uint = reqList.length;
            for (i = 0; i < reqListLen; ++i)
            {
                reqInfo = reqList[i];
                if (null != reqInfo.callback)
                {
                    if (null == reqInfo.callbackData)
                        reqInfo.callback.apply(this, [e.data]);
                    else
                        reqInfo.callback.apply(this, [e.data, reqInfo.callbackData]);
                }
            }
            
            // 清空本url的加载请求列表
            for each (reqInfo in reqList)
            {
                reqInfo.dispose();
            }
            reqList.length = 0;
            _reqListDic[trimUrl] = null;
            delete _reqListDic[trimUrl];
            
            // 归还loader
            var loader:MyLoader = _runningLoaderDic[trimUrl] as MyLoader;
            _loaderPool.push(loader);
            _runningLoaderDic[trimUrl] = null;
            delete _runningLoaderDic[trimUrl];
        }
        
        private function onLoadFailed(e:MyLoaderEvent):void
        {
            //...
        }
        
        private function onLoadProgress(e:MyLoaderEvent):void
        {
            //...
        }
        
        private function genToken():String
        {
            var token:String = "";
            do 
            {
                token = Math.random().toString();
            } while(null != _usingTokenDic[token]);
            return token;
        }
    }
}