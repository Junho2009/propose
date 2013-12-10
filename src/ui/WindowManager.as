package ui
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
    import mx.utils.StringUtil;
    
    import commons.GlobalLayers;
    import commons.manager.IWindowManager;
    
    public class WindowManager implements IWindowManager
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:WindowManager = null;
        
        private var _winClassDic:Dictionary;
        private var _winDic:Dictionary;
        
        private var _winLayer:Sprite;
        
        
        public function WindowManager()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("WindowManager is a singleton class.");
            
            _winClassDic = new Dictionary();
            _winDic = new Dictionary();
            
            _winLayer = GlobalLayers.getInstance().windowLayer;
        }
        
        /**
         * 获取当前实例 
         * @return GlobalContext
         * 
         */	
        public static function getInstance():WindowManager
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new WindowManager();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        
        
        public function register(name:String, window:Class):void
        {
            _winClassDic[name] = window;
        }
        
        public function unregister(name:String):void
        {
            if (null != _winClassDic[name])
            {
                _winClassDic[name] = null;
                delete _winClassDic[name];
            }
        }
        
        public function open(name:String, params:Object = null):void
        {
            if (null == _winClassDic[name])
                throw new IllegalOperationError(StringUtil.substitute("未注册的窗体：{0}", name));
            
            var iwindow:IWindow = null;
            var dwindow:DisplayObject = _winDic[name];
            if (null == dwindow)
            {
                dwindow = new _winClassDic[name]() as DisplayObject;
                if (null == dwindow)
                    throw new IllegalOperationError(StringUtil.substitute("所注册的窗体类{0}不是可视对象", name));
                if (!(dwindow is IWindow))
                    throw new IllegalOperationError(StringUtil.substitute("所注册的窗体类{0}没有实现IWindow接口", name));
                
                _winDic[name] = dwindow;
                
                iwindow = dwindow as IWindow;
                iwindow.init();
            }
            else
            {
                iwindow = dwindow as IWindow;
            }
            
            _winLayer.addChild(dwindow);
            
            if (null != params)
                iwindow.params = params;
        }
        
        public function close(name:String, params:Object = null):void
        {
            var window:DisplayObject = _winDic[name];
            if (null != window)
            {
                if (_winLayer.contains(window))
                    _winLayer.removeChild(window);
            }
        }
        
        public function closeByInstance(window:DisplayObject):void
        {
            const idx:int = _winLayer.getChildIndex(window);
            if (idx >= 0)
                _winLayer.removeChildAt(idx);
        }
    }
}