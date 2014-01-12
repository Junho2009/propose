package ui
{
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
    import mx.utils.StringUtil;
    
    import webgame.ui.Skin;

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
        
        [Embed(source = "../../../resources/bless/closebtn.png")]
        public var closeBtn:Class;
        
        [Embed(source = "../../../resources/bless/blesswallrope.png")]
        public var blessWallRope:Class;
        
        [Embed(source = "../../../resources/common/input_bg.png"
            , scaleGridTop = "8", scaleGridLeft = "8", scaleGridRight = "9"
            , scaleGridBottom = "9")]
        public var inputBG:Class;
        
        
        [Embed(source = "../../../resources/common/button1/up.png"
            , scaleGridLeft = "6", scaleGridRight = "7", scaleGridTop = "7"
            , scaleGridBottom = "8")]
        public var button1_up:Class;
        [Embed(source = "../../../resources/common/button1/over.png"
            , scaleGridLeft = "6", scaleGridRight = "7", scaleGridTop = "7"
            , scaleGridBottom = "8")]
        public var button1_over:Class;
        [Embed(source = "../../../resources/common/button1/down.png"
            , scaleGridLeft = "6", scaleGridRight = "7", scaleGridTop = "7"
            , scaleGridBottom = "8")]
        public var button1_down:Class;
        [Embed(source = "../../../resources/common/button1/disable.png"
            , scaleGridLeft = "6", scaleGridRight = "7", scaleGridTop = "7"
            , scaleGridBottom = "8")]
        public var button1_disable:Class;
        
        
        [Embed(source = "thankful.data", mimeType = "application/octet-stream")]
        public var thankfulData:Class;
        
        
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
        
        public function createButtonSkin(type:uint):Skin
        {
            var btnName:String = StringUtil.substitute("button{0}", type);
            
            var skin:Skin = new Skin(btnName, "button");
            
            skin.setAppearance("upSkin", getSprite(btnName + "_up"));
            skin.setAppearance("overSkin", getSprite(btnName + "_over"));
            skin.setAppearance("downSkin", getSprite(btnName + "_down"));
            skin.setAppearance("disabledSkin", getSprite(btnName + "_disable"));
            skin.setAppearance("selectedUpSkin", getSprite(btnName + "_down"));
            skin.setAppearance("selectedOverSkin", getSprite(btnName + "_down"));
            skin.setAppearance("selectedDownSkin", getSprite(btnName + "_down"));
            skin.setAppearance("selectedDisabledSkin", getSprite(btnName + "_down"));
            
            return skin;
        }
        
        public function getJObj(name:String):Object
        {
            return JSON.parse((new this[name]()).toString());
        }
    }
}