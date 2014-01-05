package flowersend
{
    import flash.errors.IllegalOperationError;
    
    import commons.GlobalContext;
    import commons.GlobalLayers;
    import commons.MathUtil;
    import commons.buses.InnerEventBus;
    import commons.buses.NetBus;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    import mud.protos.FlowerProtoOut_SendFlower;

    /**
     * 鲜花特效管理器
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public class FlowerEffect
    {
        private static var _allowInstance:Boolean = false;
        private static var _instance:FlowerEffect = null;
        
        private var _timerMgr:ITimerManager;
        
        private var _curFallRemain:int = 0;
        private var _perIntervalMin:uint;
        private var _perIntervalMax:uint;
        
        private var _flowerPool:Vector.<Flower>;
        private var _fallingFlowerList:Vector.<Flower>;
        
        
        public function FlowerEffect()
        {
            if (!_allowInstance)
                throw new IllegalOperationError("InnerEventBus is a singleton class.");
            
            _timerMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            
            _flowerPool = new Vector.<Flower>();
            _fallingFlowerList = new Vector.<Flower>();
            
            InnerEventBus.getInstance().addEventListener(FlowerEffectEvent.FlowerClicked, onFlowerClicked);
            InnerEventBus.getInstance().addEventListener(FlowerEffectEvent.FlowerTouchDown, onFlowerTouchDown);
        }
        
        public static function getInstance():FlowerEffect
        {
            if (null == _instance)
            {
                _allowInstance = true;
                _instance = new FlowerEffect();
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
            _timerMgr.clearTask(onFallFlower);
            _curFallRemain = 0;
            
            var flower:Flower = null;
            
            for each (flower in _flowerPool)
            {
                flower.dispose();
            }
            _flowerPool.length = 0;
            
            for each (flower in _fallingFlowerList)
            {
                flower.dispose();
            }
            _fallingFlowerList.length = 0;
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
            
            // 发送送花协议
            var cmd:FlowerProtoOut_SendFlower = new FlowerProtoOut_SendFlower();
            cmd.num = 1;
            NetBus.getInstance().send(cmd);
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