package commons.load
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
    import mx.utils.StringUtil;
    
    import commons.debug.Debug;
    import commons.manager.ICacheManager;
    import commons.manager.ILoadManager;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;

    /**
     * 加载管理器
     * @author junho
     * <br/>Create: 2013.12.15
     */    
    public class LoadManager implements ILoadManager
    {
        private static const _MAX_MULTI_LOAD_NUM:uint = 5; // 最多同时进行的加载请求数
        private static const _MAX_RETRY_TIMES:uint = 3; // 每个请求的最大重试次数
        private static const _RETRY_READY_SEC:uint = 5; // 重试前的等待时间
        
        private var _tm:ITimerManager;
        private var _cacheMgr:ICacheManager;
        
        private var _loaderPool:Vector.<MyLoader>;
        
        private var _reqListDic:Dictionary; // url字典，每个key为去掉根路径后的url、每个值为对应的加载请求列表
        private var _runningLoaderDic:Dictionary; // 加载中的loaders
        private var _waitingReqList:Vector.<LoadRequestInfo>; // 等待中的加载请求列表
        
        private var _waitingForRetryList:Vector.<LoadRetryInfo>; // 等待着重试的加载请求列表
        private var _retryInfoDic:Dictionary; // 记录重试信息
        
        private var _usingTokenDic:Dictionary; // 正在使用的加载请求token
        private var _freeTokenList:Vector.<String>; // 闲置的token列表
        
        
        public function LoadManager()
        {
            _tm = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            _cacheMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.CacheManager) as ICacheManager;
            
            var i:int = 0;
            
            _loaderPool = new Vector.<MyLoader>();
            for (i = 0; i < _MAX_MULTI_LOAD_NUM; ++i)
            {
                _loaderPool.push(new MyLoader());
            }
            
            _reqListDic = new Dictionary();
            _runningLoaderDic = new Dictionary();
            _waitingReqList = new Vector.<LoadRequestInfo>();
            
            _waitingForRetryList = new Vector.<LoadRetryInfo>();
            _retryInfoDic = new Dictionary();
            
            _usingTokenDic = new Dictionary();
            _freeTokenList = new Vector.<String>();
            
            _tm.setTask(tickRetryCountDown, 1000, true);
        }
        
        public function isLoading(url:String):Boolean
        {
            return (null != _runningLoaderDic[FilePath.trimRoot(url)]);
        }
        
        public function load(reqInfo:LoadRequestInfo):void
        {
            var url:String = reqInfo.url;
            
            if (null == url || "" == url)
                throw new IllegalOperationError("请求加载的url为空字符串");
            
            reqInfo.token = getToken(reqInfo.trimUrl);
            onLoadOne(reqInfo);
        }
        
        public function stopLoad(token:String):void
        {
            var trimUrl:String = _usingTokenDic[token] as String;
            if (null == trimUrl)
                throw new IllegalOperationError(StringUtil.substitute("不存在的token: {0}", token));
            
            var i:int = 0;
            var reqInfo:LoadRequestInfo = null;
            
            var reqList:Vector.<LoadRequestInfo> = _reqListDic[trimUrl] as Vector.<LoadRequestInfo>;
            if (null != reqList)
            {
                const reqListLen:uint = reqList.length;
                if (1 == reqListLen)
                {
                    if (token == reqList[0].token)
                    {
                        // 归还loader
                        var loader:MyLoader = _runningLoaderDic[trimUrl] as MyLoader;
                        loader.stopLoad();
                        _loaderPool.push(loader);
                        _runningLoaderDic[trimUrl] = null;
                        delete _runningLoaderDic[trimUrl];
                        
                        reqList.length = 0;
                        _reqListDic[trimUrl] = null;
                        delete _reqListDic[trimUrl];
                    }
                }
                else
                {
                    for (i = 0; i < reqListLen; ++i)
                    {
                        reqInfo = reqList[i];
                        if (token == reqInfo.token)
                        {
                            reqList.splice(i, 1);
                            break;
                        }
                    }
                }
            }
            else
            {
                const waitingReqListLen:uint = _waitingReqList.length;
                for (i = 0; i < waitingReqListLen; ++i)
                {
                    reqInfo = _waitingReqList[i];
                    if (token == reqInfo.token)
                    {
                        _waitingReqList.splice(i, 1);
                        break;
                    }
                }
            }
            
            // 归还token
            giveBackToken(token);
            
            handleWaitingReqList();
        }
        
        public function isLoadingList(reqInfo:LoadRequestInfo):Boolean
        {
            return (null != _runningLoaderDic[reqInfo]);
        }
        
        public function loadList(reqInfo:LoadRequestInfo):void
        {
            var urlList:Vector.<String> = reqInfo.urlList;
            
            if (null == urlList || 0 == urlList.length)
                throw new IllegalOperationError("加载请求列表为空");
            
            reqInfo.token = getToken(reqInfo);
            onLoadList(reqInfo);
        }
        
        public function stopLoadList(token:String):void
        {
            var reqInfo:LoadRequestInfo = _usingTokenDic[token] as LoadRequestInfo;
            if (null == reqInfo)
                throw new IllegalOperationError(StringUtil.substitute("不存在的token: {0}", token));
            
            var i:int = 0;
            
            var loader:MyLoader = _runningLoaderDic[reqInfo] as MyLoader;
            if (null != loader)
            {
                loader.stopLoad();
                
                // 归还loader
                _loaderPool.push(loader);
                _runningLoaderDic[reqInfo] = null;
                delete _runningLoaderDic[reqInfo];
            }
            else
            {
                const waitingReqListLen:uint = _waitingReqList.length;
                for (i = 0; i < waitingReqListLen; ++i)
                {
                    reqInfo = _waitingReqList[i];
                    if (token == reqInfo.token)
                    {
                        _waitingReqList.splice(i, 1);
                        break;
                    }
                }
            }
            
            // 归还token
            giveBackToken(token);
            
            handleWaitingReqList();
        }
        
        
        
        private function hasFreeLoader():Boolean
        {
            return (_loaderPool.length > 0);
        }
        
        private function getSingleFileLoader():MyLoader
        {
            var loader:MyLoader = null;
            if (_loaderPool.length > 0)
            {
                loader = _loaderPool.shift();
                loader.removeListeners();
                loader.addEventListener(MyLoaderEvent.COMPLETE, onLoadCompleted_SingleFile);
                loader.addEventListener(MyLoaderEvent.FAILED, onLoadFailed_SingleFile);
                loader.addEventListener(MyLoaderEvent.PROGRESS, onLoadProgress_SingleFile);
            }
            return loader;
        }
        
        private function getFileListLoader():MyLoader
        {
            var loader:MyLoader = null;
            if (_loaderPool.length > 0)
            {
                loader = _loaderPool.shift();
                loader.removeListeners();
                loader.addEventListener(MyLoaderEvent.COMPLETE, onLoadCompleted_FileInList);
                loader.addEventListener(MyLoaderEvent.FAILED, onLoadFailed_FileInList);
                loader.addEventListener(MyLoaderEvent.PROGRESS, onLoadProgress_FileInList);
            }
            return loader;
        }
        
        private function onLoadCompleted_SingleFile(e:MyLoaderEvent):void
        {
            _cacheMgr.addData(e.rawData, e.url);
            
            var trimUrl:String = FilePath.trimRoot(e.url);
            var reqList:Vector.<LoadRequestInfo> = _reqListDic[trimUrl] as Vector.<LoadRequestInfo>;
            var i:int = 0;
            var reqInfo:LoadRequestInfo = null;
            const reqListLen:uint = reqList.length;
            for (i = 0; i < reqListLen; ++i)
            {
                reqInfo = reqList[i];
                if (null != reqInfo.completedCallback)
                {
                    if (null == reqInfo.completedCallbackData)
                        reqInfo.completedCallback.apply(this, [e.data]); // 注：目前对于相同url的加载请求，返回给回调函数的文件对象都是同一个
                    else
                        reqInfo.completedCallback.apply(this, [e.data, reqInfo.completedCallbackData]);
                }
            }
            
            // 清空本url的加载请求列表
            for each (reqInfo in reqList)
            {
                giveBackToken(reqInfo.token);
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
            
            handleWaitingReqList();
        }
        
        private function onLoadFailed_SingleFile(e:MyLoaderEvent):void
        {
            var trimUrl:String = FilePath.trimRoot(e.url);
            
            var i:int = 0;
            var reqInfo:LoadRequestInfo = null;
            var retryInfo:LoadRetryInfo = null;
            var bRetry:Boolean = false;
            
            var reqList:Vector.<LoadRequestInfo> = _reqListDic[trimUrl] as Vector.<LoadRequestInfo>;
            
            const reqListLen:uint = reqList.length;
            for (i = 0; i < reqListLen; ++i)
            {
                reqInfo = reqList[i];
                
                giveBackToken(reqInfo.token);
                
                if (reqInfo.isNeetToRetry)
                {
                    retryInfo = _retryInfoDic[reqInfo] as LoadRetryInfo;
                    if (null == retryInfo)
                    {
                        retryInfo = new LoadRetryInfo();
                        retryInfo.reqInfo = reqInfo;
                        _retryInfoDic[reqInfo] = retryInfo;
                        
                        _waitingForRetryList.push(retryInfo);
                        bRetry = true;
                    }
                    else
                    {
                        if (retryInfo.retriedTimes < _MAX_RETRY_TIMES)
                        {
                            retryInfo.readyTime = 0;
                            _waitingForRetryList.push(retryInfo);
                            bRetry = true;
                        }
                        else
                        {
                            retryInfo.dispose();
                            
                            _retryInfoDic[reqInfo] = null;
                            delete _retryInfoDic[reqInfo];
                        }
                    }
                }
                
                if (!bRetry)
                {
                    if (null != reqInfo.failCallback)
                    {
                        if (null == reqInfo.failCallbackData)
                            reqInfo.failCallback.apply(this);
                        else
                            reqInfo.failCallback.apply(this, [reqInfo.failCallbackData]);
                    }
                    
                    reqInfo.dispose();
                }
            }
            
            // 清空本url的加载请求列表
            reqList.length = 0;
            _reqListDic[trimUrl] = null;
            delete _reqListDic[trimUrl];
            
            // 归还loader
            var loader:MyLoader = _runningLoaderDic[trimUrl] as MyLoader;
            loader.stopLoad();
            _loaderPool.push(loader);
            _runningLoaderDic[trimUrl] = null;
            delete _runningLoaderDic[trimUrl];
            
            handleWaitingReqList();
        }
        
        private function onLoadProgress_SingleFile(e:MyLoaderEvent):void
        {
            //...
        }
        
        
        
        private function onLoadCompleted_FileInList(e:MyLoaderEvent):void
        {
            var reqInfo:LoadRequestInfo = e.param as LoadRequestInfo;
            var loader:MyLoader = null;
            var url:String = "";
            
            if (null != reqInfo.singleCompCallback)
                reqInfo.singleCompCallback.apply(this, [e.url, e.data]);
            
            loader = _runningLoaderDic[reqInfo] as MyLoader;
            if (null != loader)
            { // 若loader为null，原因可能是调用singleCompCallback的过程中停止了列表的加载
                if (reqInfo.urlList.length > 0)
                {
                    url = reqInfo.urlList.shift();
                    loader.load(url, reqInfo);
                }
                else
                {
                    if (null != reqInfo.completedCallback)
                    {
                        if (null == reqInfo.completedCallbackData)
                            reqInfo.completedCallback.apply(this);
                        else
                            reqInfo.completedCallback.apply(this, [reqInfo.completedCallbackData]);
                    }
                    
                    // 归还token
                    giveBackToken(reqInfo.token);
                    
                    // 归还loader
                    loader = _runningLoaderDic[reqInfo] as MyLoader;
                    _loaderPool.push(loader);
                    _runningLoaderDic[reqInfo] = null;
                    delete _runningLoaderDic[reqInfo];
                    
                    handleWaitingReqList();
                }
            }
        }
        
        private function onLoadFailed_FileInList(e:MyLoaderEvent):void
        {
            var reqInfo:LoadRequestInfo = e.param as LoadRequestInfo;
            
            giveBackToken(reqInfo.token);
            
            // 归还loader
            var loader:MyLoader = _runningLoaderDic[reqInfo] as MyLoader;
            _loaderPool.push(loader);
            _runningLoaderDic[reqInfo] = null;
            delete _runningLoaderDic[reqInfo];
            
            var retryInfo:LoadRetryInfo = null;
            var bRetry:Boolean = false;
            if (reqInfo.isNeetToRetry)
            {
                retryInfo = _retryInfoDic[reqInfo] as LoadRetryInfo;
                if (null == retryInfo)
                {
                    retryInfo = new LoadRetryInfo();
                    retryInfo.reqInfo = reqInfo;
                    _retryInfoDic[reqInfo] = retryInfo;
                    
                    _waitingForRetryList.push(retryInfo);
                    bRetry = true;
                }
                else
                {
                    if (retryInfo.retriedTimes < _MAX_RETRY_TIMES)
                    {
                        retryInfo.readyTime = 0;
                        _waitingForRetryList.push(retryInfo);
                        bRetry = true;
                    }
                    else
                    {
                        retryInfo.dispose();
                        
                        _retryInfoDic[reqInfo] = null;
                        delete _retryInfoDic[reqInfo];
                    }
                }
            }
            
            if (!bRetry)
            {
                if (null != reqInfo.failCallback)
                {
                    if (null == reqInfo.failCallbackData)
                        reqInfo.failCallback.apply(this);
                    else
                        reqInfo.failCallback.apply(this, [reqInfo.failCallbackData]);
                }
                
                reqInfo.dispose();
            }
            
            handleWaitingReqList();
        }
        
        private function onLoadProgress_FileInList(e:MyLoaderEvent):void
        {
            //...
        }
        
        private function getToken(param:Object):String
        {
            var token:String = "";
            
            if (_freeTokenList.length > 0)
            {
                token = _freeTokenList.shift();
            }
            else
            {
                do 
                {
                    token = Math.random().toString();
                } while(null != _usingTokenDic[token]);
            }
            
            _usingTokenDic[token] = param;
            
            return token;
        }
        
        private function giveBackToken(token:String):void
        {
            _freeTokenList.push(token);
            _usingTokenDic[token] = null;
            delete _usingTokenDic[token];
        }
        
        private function handleWaitingReqList():void
        {
            if (_waitingReqList.length > 0 && hasFreeLoader())
            {
                var reqInfo:LoadRequestInfo = null;
                
                reqInfo = _waitingReqList.shift();
                if (null != reqInfo.urlList)
                    onLoadList(reqInfo);
                else
                    onLoadOne(reqInfo);
            }
        }
        
        private function onLoadOne(reqInfo:LoadRequestInfo):void
        {
            var url:String = reqInfo.url;
            
            var loader:MyLoader = null;
            var reqList:Vector.<LoadRequestInfo> = null;
            
            if (!isLoading(url))
            {
                loader = getSingleFileLoader();
                if (null != loader)
                {
                    reqList = new Vector.<LoadRequestInfo>();
                    _reqListDic[reqInfo.trimUrl] = reqList;
                    reqList.push(reqInfo);
                    
                    _runningLoaderDic[reqInfo.trimUrl] = loader;
                    
                    var cache:* = _cacheMgr.getData(url);
                    if (null != cache)
                    {
                        loader.loadCache(url, cache);
                    }
                    else
                    {
                        loader.load(url);
                    }
                }
                else
                {
                    _waitingReqList.push(reqInfo);
                }
            }
            else
            {
                reqList = _reqListDic[reqInfo.trimUrl] as Vector.<LoadRequestInfo>;
                reqList.push(reqInfo);
            }
        }
        
        private function onLoadList(reqInfo:LoadRequestInfo):void
        {
            var urlList:Vector.<String> = reqInfo.urlList;
            var loader:MyLoader = getFileListLoader();
            if (null != loader)
            {
                var url:String = urlList.shift();
                _runningLoaderDic[reqInfo] = loader;
                loader.load(url, reqInfo);
            }
            else
            {
                _waitingReqList.push(reqInfo);
            }
        }
        
        private function tickRetryCountDown():void
        {
            var retryInfo:LoadRetryInfo = null;
            var timeUpIdxList:Vector.<int> = new Vector.<int>();
            var i:int = 0;
            
            const waitingForRetryListLen:uint = _waitingForRetryList.length;
            for (i = 0; i < waitingForRetryListLen; ++i)
            {
                retryInfo = _waitingForRetryList[i];
                if (++retryInfo.readyTime > _RETRY_READY_SEC)
                {
                    _waitingReqList.push(retryInfo.reqInfo);
                    timeUpIdxList.push(i);
                    
                    ++retryInfo.retriedTimes;
                    
                    Debug.log("准备第{0}次重试加载：{1}", retryInfo.retriedTimes, retryInfo.reqInfo.url);
                }
            }
            
            for (i = timeUpIdxList.length-1; i >= 0; --i)
            {
                _waitingForRetryList.splice(timeUpIdxList[i], 1);
            }
            
            if (timeUpIdxList.length > 0)
                handleWaitingReqList();
        }
    }
}