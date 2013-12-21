package effect
{
    import flash.errors.IllegalOperationError;
    
    import commons.GlobalContext;
    import commons.GlobalLayers;
    import commons.MathUtil;
    import commons.buses.InnerEventBus;
    import commons.debug.Debug;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;

    /**
     * 鲜花特效管理器
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public class FlowerEffectManager
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:FlowerEffectManager = null;
        
        private var _timerMgr:ITimerManager;
        
        private var _curFallRemain:int = 0;
        private var _perIntervalMin:uint;
        private var _perIntervalMax:uint;
        
        private var _flowerPool:Vector.<Flower>;
        private var _fallingFlowerList:Vector.<Flower>;
        
        
        public function FlowerEffectManager()
        {
            if (!_allowInstance)
                throw new IllegalOperationError("InnerEventBus is a singleton class.");
            
            _timerMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            
            _flowerPool = new Vector.<Flower>();
            _fallingFlowerList = new Vector.<Flower>();
            
            InnerEventBus.getInstance().addEventListener(FlowerEffectEvent.FlowerClicked, onFlowerClicked);
            InnerEventBus.getInstance().addEventListener(FlowerEffectEvent.FlowerTouchDown, onFlowerTouchDown);
            
            _timerMgr.setTask(function():void
            {
                Debug.log("=========_flowerPool len: {0}", _flowerPool.length);
                Debug.log("=========_fallingFlowerList len: {0}", _fallingFlowerList.length);
            }, 1000, true);
        }
        
        public static function getInstance():FlowerEffectManager
        {
            if (null == _instance)
            {
                _allowInstance = true;
                _instance = new FlowerEffectManager();
                _allowInstance = false;
            }
            return _instance;
        }
        
        public function fallFlowers(total:uint, perIntervalMin:uint = 100, perIntervalMax:uint = 300):void
        {
            _curFallRemain = total;
            _perIntervalMin = perIntervalMin;
            _perIntervalMax = perIntervalMax;
            
            _timerMgr.clearTask(onFallFlower);
            _timerMgr.setTask(onFallFlower, genIntervalTime());
        }
        
        public function clear():void
        {
            
        }
        
        
        
        private function onFallFlower():void
        {
            var flower:Flower = getUsableFlower();
            flower.x = MathUtil.randomInt(0, GlobalContext.getInstance().stage.stageWidth - Flower.DefaultW);
            flower.y = -Flower.DefaultH;
            GlobalLayers.getInstance().effectLayer.addChild(flower);
            _fallingFlowerList.push(flower);
            flower.beginFall();
            
            --_curFallRemain;
            if (_curFallRemain > 0)
            {
                _timerMgr.clearTask(onFallFlower);
                _timerMgr.setTask(onFallFlower, genIntervalTime());
            }
        }
        
        private function genIntervalTime():uint
        {
            return MathUtil.randomInt(_perIntervalMin, _perIntervalMax);
        }
        
        private function getUsableFlower():Flower
        {
            var flower:Flower = null;
            
            if (_flowerPool.length > 0)
                flower = _flowerPool.shift();
            else
                flower = new Flower();
            
            flower.type = MathUtil.randomInt(1, 4);
            flower.speed = MathUtil.randomInt(150, 300);
            
            return flower;
        }
        
        private function onFlowerClicked(e:FlowerEffectEvent):void
        {
            var flower:Flower = e.data as Flower;
            giveBackFlower(flower);
            
            //TODO: 发送送花协议
        }
        
        private function onFlowerTouchDown(e:FlowerEffectEvent):void
        {
            var flower:Flower = e.data as Flower;
            giveBackFlower(flower);
        }
        
        private function giveBackFlower(flower:Flower):void
        {
            const idx:int = _fallingFlowerList.indexOf(flower);
            if (idx < 0)
                return;
            
            _fallingFlowerList.splice(idx, 1);
            
            if (null != flower.parent)
                flower.parent.removeChild(flower);
            
            _flowerPool.push(flower);
        }
    }
}