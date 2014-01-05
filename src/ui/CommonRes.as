package ui
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;

    /**
     * 公共资源
     * @author junho
     * <br/>Create: 2013.12.20
     */    
    public class CommonRes
    {
        [Embed(source = "../../../resources/bless/paper1.png")]
        public var blessPaper1:Class;
        
        [Embed(source = "../../../resources/bless/paper2.png")]
        public var blessPaper2:Class;
        
        [Embed(source = "../../../resources/bless/paper3.png")]
        public var blessPaper3:Class;
        
        [Embed(source = "../../../resources/bless/paper4.png")]
        public var blessPaper4:Class;
        
//        [Embed(source = "../../../resources/bless/closebtn.png")]
//        public var blessPaperCloseBtn:Class;
        
        [Embed(source = "../../../resources/bless/blesswallrope.png")]
        public var blessWallRope:Class;
        
        [Embed(source = "../../../resources/common/input_bg.png"
            , scaleGridTop = "8", scaleGridLeft = "8", scaleGridRight = "9"
            , scaleGridBottom = "9")]
        public var inputBG:Class;
        
        
        private static var _isAllowInstance:Boolean = false;
        private static var _instance:CommonRes = null;
        
        private var _bitmapResDic:Dictionary = new Dictionary();
        
        
        public function CommonRes()
        {
            if (!_isAllowInstance)
            {
                throw new IllegalOperationError("Can not instance CommonRes");
            }
        }
        
        public static function getInstance():CommonRes
        {
            if (null == _instance)
            {
                _isAllowInstance = true;
                _instance = new CommonRes();
                _isAllowInstance = false;
            }
            return _instance;
        }
        
        public function getBitmap(resName:String):Bitmap
        {
            var bmpCache:Bitmap = _bitmapResDic[resName];
            if (null == bmpCache)
            {
                bmpCache = Bitmap(new this[resName]());
                _bitmapResDic[resName] = bmpCache;
            }
            return new Bitmap(bmpCache.bitmapData);
        }
        
        public function getSprite(resName:String):Sprite
        {
            return Sprite(new this[resName]());
        }
    }
}