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
        private var _scene3dLayer:Sprite;
        private var _windowLayer:Sprite;
        private var _effectLayer:Sprite;
        private var _msgLayer:Sprite;
        
        
        public function GlobalLayers()
        {
            if(!_allowInstance)
                throw new IllegalOperationError("GlobalLayers is a singleton class.");
            
            var stage:Stage = GlobalContext.getInstance().stage;
            
            _bgLayer = new Sprite();
            stage.addChild(_bgLayer);
            
            _scene3dLayer = new Sprite();
            stage.addChild(_scene3dLayer);
            
            _windowLayer = new Sprite();
            stage.addChild(_windowLayer);
            
            _effectLayer = new Sprite();
            stage.addChild(_effectLayer);
            
            _msgLayer = new Sprite();
            stage.addChild(_msgLayer);
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
        
        public function get scene3dLayer():Sprite
        {
            return _scene3dLayer;
        }
        
        public function get windowLayer():Sprite
        {
            return _windowLayer;
        }
        
        public function get effectLayer():Sprite
        {
            return _effectLayer;
        }
        
        public function get msgLayer():Sprite
        {
            return _msgLayer;
        }
    }
}