package ui
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import mx.utils.StringUtil;
    
    import commons.GlobalContext;
    import commons.GlobalLayers;
    import commons.manager.IWindowManager;
    
    /**
     * 窗体管理器
     * @author junho
     * <br/>Create: 2013.12.20
     */    
    public class WindowManager implements IWindowManager
    {
        private var _winClassDic:Dictionary;
        private var _winDic:Dictionary;
        
        private var _winLayer:Sprite;
        
        
        public function WindowManager()
        {
            _winClassDic = new Dictionary();
            _winDic = new Dictionary();
            
            _winLayer = GlobalLayers.getInstance().windowLayer;
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
        
        public function open(name:String, pos:Point = null, params:Object = null):void
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
            
            if (null == pos)
            {
                dwindow.x = GlobalContext.getInstance().stage.stageWidth - dwindow.width >> 1;
                dwindow.y = GlobalContext.getInstance().stage.stageHeight - dwindow.height >> 1;
            }
            else
            {
                dwindow.x = pos.x;
                dwindow.y = pos.y;
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