package commons
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.errors.IllegalOperationError;

    public final class GlobalLayers
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:GlobalLayers = null;
        
        private var _bgLayer:Sprite;
        private var _windowLayer:Sprite;
        
        
        public function GlobalLayers()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("GlobalLayers is a singleton class.");
            
            var stage:Stage = GlobalContext.getInstance().stage;
            
            _bgLayer = new Sprite();
            stage.addChild(_bgLayer);
            
            _windowLayer = new Sprite();
            stage.addChild(_windowLayer);
        }
        
        /**
         * 获取当前实例 
         * @return GlobalContext
         * 
         */	
        public static function getInstance():GlobalLayers
        {
            if(null == _instance)
            {
                _allowInstance = true;
                _instance = new GlobalLayers();
                _allowInstance = false;
            }
            
            return _instance;
        }
        
        
        
        public function get bgLayer():Sprite
        {
            return _bgLayer;
        }
        
        public function get windowLayer():Sprite
        {
            return _windowLayer;
        }
    }
}