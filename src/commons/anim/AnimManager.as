package commons.anim
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
    import commons.manager.IAnimManager;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    
    /**
     * 动画管理器
     * <br/>创建动画，并提供统一管理那些不手动控制的动画的接口
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public class AnimManager implements IAnimManager
    {
        private var _timerMgr:ITimerManager;
        
        private var _animClassDic:Dictionary;
        private var _animDic:Dictionary;
        
        
        public function AnimManager()
        {
            _timerMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            _animDic = new Dictionary();
            
            registerAnimClasses();
        }
        
        public function createAnim(animType:String, rawData:Object, dataKey:* = null):IAnimation
        {
            var anim:IAnimation = null;
            
            var animClass:Class = _animClassDic[animType] as Class;
            if (null != animClass)
            {
                anim = new animClass();
                anim.init(rawData, dataKey);
            }
            
            return anim;
        }
        
        public function addAnim(anim:IAnimation):void
        {
            if (null != _animDic[anim])
                throw new IllegalOperationError("重复添加动画");
            
            _animDic[anim] = true;
            _timerMgr.setTask(anim.tickFrame, 1000/anim.fps, true);
        }
        
        public function removeAnim(anim:IAnimation):void
        {
            if (null == _animDic[anim])
                return;
            
            _timerMgr.clearTask(anim.tickFrame);
            
            _animDic[anim] = null;
            delete _animDic[anim];
        }
        
        
        private function registerAnimClasses():void
        {
            _animClassDic = new Dictionary();
            _animClassDic[AnimType.BitmapMC] = BitmapMC;
        }
    }
}