package flowersend
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import mx.utils.StringUtil;
    
    import caurina.transitions.Tweener;
    
    import commons.GlobalContext;
    import commons.anim.AnimType;
    import commons.anim.BitmapMC;
    import commons.buses.InnerEventBus;
    import commons.load.FilePath;
    import commons.load.LoadRequestInfo;
    import commons.manager.IAnimManager;
    import commons.manager.ILoadManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    public class Flower extends Sprite
    {
        public static const DefaultW:Number = 36;
        public static const DefaultH:Number = 36;
        
        private var _loadMgr:ILoadManager;
        private var _animMgr:IAnimManager;
        
        private var _flowerMC:BitmapMC;
        private var _type:uint;
        private var _speed:Number;
        
        
        public function Flower()
        {
            super();
            
            _loadMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoadManager) as ILoadManager;
            _animMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.AnimManager) as IAnimManager;
            
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_DOWN, onClick);
        }
        
        public function init():void
        {
            disposeFlowerMC();
        }
        
        public function set type(value:uint):void
        {
            if (value == _type)
                return;
            
            _type = value;
            
            disposeFlowerMC();
            
            var reqInfo:LoadRequestInfo = new LoadRequestInfo();
            reqInfo.url = StringUtil.substitute("{0}{1}.swf", FilePath.flowerPath, value);
            reqInfo.completedCallback = onFlowerLoaded;
            _loadMgr.load(reqInfo);
        }
        
        public function set speed(value:Number):void
        {
            _speed = value;
        }
        
        public function beginFall():void
        {
            Tweener.removeTweens(this);
            
            const targetY:Number = GlobalContext.getInstance().stage.stageHeight + DefaultH;
            
            alpha = 1;
            
            var params:Object = new Object();
            params.y = targetY;
            params.time = (targetY - y) / _speed;
            params.transition = "linear";
            params.onComplete = onTouchDown;
            
            Tweener.removeTweens(this);
            Tweener.addTween(this, params);
        }
        
        public function dispose():void
        {
            disposeFlowerMC();
        }
        
        
        
        private function onClick(e:MouseEvent):void
        {
            Tweener.removeTweens(this);
            
            var params:Object = new Object();
            params.x = GlobalContext.getInstance().stage.stageWidth - this.width >> 1;
            params.y = GlobalContext.getInstance().stage.stageHeight - this.height - 10;
            params.alpha = 0;
            params.time = 0.5;
            params.transition = "linear";
            params.onComplete = function():void
            {
                InnerEventBus.getInstance().dispatchEvent(new FlowerEffectEvent(FlowerEffectEvent.FlowerClicked, this));
            };
            
            Tweener.removeTweens(this);
            Tweener.addTween(this, params);
        }
        
        private function onFlowerLoaded(mc:MovieClip):void
        {
            _flowerMC = _animMgr.createAnim(AnimType.BitmapMC, mc) as BitmapMC;
            _animMgr.addAnim(_flowerMC);
            _flowerMC.fps = 15;
            _flowerMC.isLoop = true;
            addChild(_flowerMC);
        }
        
        private function onTouchDown():void
        {
            InnerEventBus.getInstance().dispatchEvent(new FlowerEffectEvent(FlowerEffectEvent.FlowerTouchDown, this));
        }
        
        private function disposeFlowerMC():void
        {
            if (null != _flowerMC)
            {
                _animMgr.removeAnim(_flowerMC);
                
                if (null != _flowerMC.parent)
                    _flowerMC.parent.removeChild(_flowerMC);
                
                _flowerMC.dispose();
                _flowerMC = null;
            }
        }
    }
}