package commons
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageQuality;
    import flash.display.StageScaleMode;
    import flash.errors.IllegalOperationError;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;

    /**
     * 全局上下文
     * @author Junho
     * <br/>Create: 2013.11.27
     */    
    public final class GlobalContext
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:GlobalContext = null;
        
        private static var _bSetRoot:Boolean = false;
        private var _root:Sprite = null;
        private var _stage:Stage = null;
        private var _loaderContext:LoaderContext = null;
        
        private var _config:GlobalConfig = null;
        
        private var _bRecordLog:Boolean = false;
        
        private var _screenResolutionLV:uint = ScreenResolutionLV.LOW;
        
        
        public function GlobalContext()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("GlobalContext is a singleton class.");
            
            _config = GlobalConfig.getInstance();
        }
        
        /**
         * 获取当前实例 
         * @return GlobalContext
         * 
         */	
        public static function getInstance():GlobalContext
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new GlobalContext();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        public static function init(root:Sprite):void
        {
            if (null == root)
                throw new IllegalOperationError("root不能为空");
            
            if (!_bSetRoot)
            {
                var context:GlobalContext = GlobalContext.getInstance();
                context._root = root;
                context._stage = root.stage;
                context._loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
                
                context._stage.align = StageAlign.TOP_LEFT;
                context._stage.scaleMode = StageScaleMode.NO_SCALE;
                context._stage.quality = StageQuality.HIGH;
                
                context.initScreenResolutionLV();
                
                _bSetRoot = true;
            }
            else
            {
                throw new IllegalOperationError("不能重复初始化");
            }
        }
        
        
        
        public function get stage():Stage
        {
            return _stage;
        }
        
        public function get loaderContext():LoaderContext
        {
            return _loaderContext;
        }
        
        public function get config():GlobalConfig
        {
            return _config;
        }
        
        public function get isRecordLog():Boolean
        {
            return _bRecordLog;
        }
        
        public function get screenResolutionLV():uint
        {
            return _screenResolutionLV;
        }
        
        
        
        private function initScreenResolutionLV():void
        {
            const stageH:Number = stage.stageHeight;
            if (stageH <= 600)
                _screenResolutionLV = ScreenResolutionLV.LOW;
            else if (stageH <= 700)
                _screenResolutionLV = ScreenResolutionLV.MID;
            else
                _screenResolutionLV = ScreenResolutionLV.HIGH;
        }
    }
}