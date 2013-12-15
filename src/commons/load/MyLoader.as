package commons.load
{
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    
    import commons.GlobalContext;
    import commons.debug.Debug;
    
    /**
     * 加载器
     * <br/>负责从网络加载各种类型的文件，加载完毕后，通过事件返回文件所代表的数据对象
     * <br/>注意：对于本加载器的事件监听器，每种事件类型只对应一个监听器，重复添加侦听的话只会对第一次侦听有效
     * @author junho
     * <br/>Create: 2013.12.14
     */    
    public class MyLoader extends EventDispatcher
    {
        private var _urlReq:URLRequest;
        private var _urlLoader:URLLoader;
        private var _bUrlLoading:Boolean = false;
        
        private var _loader:Loader;
        private var _loaderLoading:Boolean = false;
        
        private var _listenerDic:Dictionary;
        
        private var _url:String;
        private var _fileType:String;
        private var _param:Object;
        
        
        public function MyLoader()
        {
            super();
            
            _urlReq = new URLRequest();
            
            _urlLoader = new URLLoader();
            _urlLoader.addEventListener(ProgressEvent.PROGRESS, onUrlLoadProgress);
            _urlLoader.addEventListener(Event.COMPLETE, onUrlLoadCompleted);
            _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onUrlIOError);
            _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlSecurityError);
            
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDisplayObjLoadCompleted);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onDisplayObjLoadIOError);
            _loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDisplayObjLoadSecurityError);
            
            _listenerDic = new Dictionary();
        }
        
        public function load(url:String, param:Object = null):void
        {
            _url = url;
            _fileType = FileType.getFileType(url);
            _param = param;
            
            switch (_fileType)
            {
                case FileType.PNG:
                case FileType.JPG:
                case FileType.SWF:
                    _urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
                    break;
                    
                default:
                    Debug.log("MyLoader.load(): 尝试加载未定义的文件类型{0}", _fileType);
                    return;
            }
            
            _urlReq.url = url; //TODO: 这里可加上版本号，用作版本管理
            
            _bUrlLoading = true;
            _urlLoader.load(_urlReq);
        }
        
        public function stopLoad():void
        {
            if (_bUrlLoading)
            {
                _urlLoader.close();
                _bUrlLoading = false;
            }
            
            if (_loaderLoading)
            {
                _loader.close();
                _loaderLoading = false;
            }
        }
        
        public function removeListeners():void
        {
            for (var key:* in _listenerDic)
            {
                removeEventListener(String(key), _listenerDic[key] as Function);
            }
        }
        
        public function dispose():void
        {
            removeListeners();
            _listenerDic = null;
            
            stopLoad();
        }
        
        
        
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
        {
            if (null != _listenerDic[type])
                return;
            _listenerDic[type] = listener;
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
        {
            if (null == _listenerDic[type])
                return;
            _listenerDic[type] = null;
            delete _listenerDic[type];
            super.removeEventListener(type, listener, useCapture);
        }
        
        
        
        private function onUrlLoadProgress(e:ProgressEvent):void
        {
            if (hasEventListener(MyLoaderEvent.PROGRESS))
            {
                var progInfo:Object = new Object();
                progInfo.bytesLoaded = e.bytesLoaded;
                progInfo.bytesTotal = e.bytesTotal;
                dispatchEvent(new MyLoaderEvent(MyLoaderEvent.PROGRESS, _url, progInfo, _param));
            }
        }
        
        private function onUrlLoadCompleted(e:Event):void
        {
            _bUrlLoading = false;
            
            switch (_fileType)
            {
                case FileType.PNG:
                case FileType.JPG:
                case FileType.SWF:
                    _loaderLoading = true
                    _loader.loadBytes(_urlLoader.data, GlobalContext.getInstance().loaderContext);
                    break;
                
                default:
                    dispatchEvent(new MyLoaderEvent(MyLoaderEvent.COMPLETE, _url, _urlLoader.data, _param));
                    break;
            }
        }
        
        private function onUrlIOError(e:Event):void
        {
            _bUrlLoading = false;
            Debug.log("URL加载发生IO错误，url：{0}", _url);
            dispatchEvent(new MyLoaderEvent(MyLoaderEvent.FAILED, _url, _loader.content, _param));
        }
        
        private function onUrlSecurityError(e:SecurityErrorEvent):void
        {
            _bUrlLoading = false;
            Debug.log("URL加载发生安全错误，url：{0}", _url);
            dispatchEvent(new MyLoaderEvent(MyLoaderEvent.FAILED, _url, _loader.content, _param));
        }
        
        
        
        private function onDisplayObjLoadCompleted(e:Event):void
        {
            _loaderLoading = false;
            dispatchEvent(new MyLoaderEvent(MyLoaderEvent.COMPLETE, _url, _loader.content, _param));
        }
        
        private function onDisplayObjLoadIOError(e:IOErrorEvent):void
        {
            _loaderLoading = false;
            Debug.log("显示对象加载发生IO错误，url：{0}", _url);
            dispatchEvent(new MyLoaderEvent(MyLoaderEvent.FAILED, _url, _loader.content, _param));
        }
        
        private function onDisplayObjLoadSecurityError(e:SecurityErrorEvent):void
        {
            _loaderLoading = false;
            Debug.log("显示对象加载发生安全错误，url：{0}", _url);
            dispatchEvent(new MyLoaderEvent(MyLoaderEvent.FAILED, _url, _loader.content, _param));
        }
    }
}