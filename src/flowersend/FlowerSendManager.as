package flowersend
{
    import commons.buses.InnerEventBus;
    import commons.buses.NetBus;
    import commons.manager.IFlowerSendManager;
    import commons.manager.ILoginManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.protos.ProtoInList;
    
    import mud.protos.FlowerProtoIn_SendLimInfo;
    import mud.protos.FlowerProtoIn_SentInfo;
    
    /**
     * 鲜花赠送管理器
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerSendManager implements IFlowerSendManager
    {
        private var _loginMgr:ILoginManager;
        
        private var _flowerEffect:FlowerEffect;
        
        private var _selfSentNum:uint = 0;
        private var _totalSentNum:uint = 0;
        
        
        public function FlowerSendManager()
        {
            _loginMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoginManager) as ILoginManager;
            
            _flowerEffect = FlowerEffect.getInstance();
            
            ProtoInList.getInstance().bind(FlowerProtoIn_SentInfo.HEAD, FlowerProtoIn_SentInfo);
            ProtoInList.getInstance().bind(FlowerProtoIn_SendLimInfo.HEAD, FlowerProtoIn_SendLimInfo);
            
            NetBus.getInstance().addCallback(FlowerProtoIn_SentInfo.HEAD, onRecvSentInfo);
            NetBus.getInstance().addCallback(FlowerProtoIn_SendLimInfo.HEAD, onRecvSendLimInfo);
        }
        
        public function get selfSentNum():uint
        {
            return _selfSentNum;
        }
        
        public function get totalSentNum():uint
        {
            return _totalSentNum;
        }
        
        
        
        // 协议处理
        
        private function onRecvSentInfo(inc:FlowerProtoIn_SentInfo):void
        {
            if (!_loginMgr.isLogined)
                return;
            
            if (inc.selfSentNum >= 0)
                _selfSentNum = inc.selfSentNum;
            _totalSentNum = inc.sentTotal;
            
            InnerEventBus.getInstance().dispatchEvent(new FlowerSendEvent(FlowerSendEvent.SentInfoUpdated));
        }
        
        private function onRecvSendLimInfo(inc:FlowerProtoIn_SendLimInfo):void
        {
            if (!_loginMgr.isLogined)
                return;
            
            const averageTime:uint = inc.duration / inc.limitCount * 1000;
            _flowerEffect.fallFlowers(inc.limitCount, averageTime / 2, averageTime * 1.5);
        }
    }
}