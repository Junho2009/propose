package flowersend
{
    import mx.utils.StringUtil;
    
    import commons.WindowGlobalName;
    import commons.buses.InnerEventBus;
    import commons.buses.NetBus;
    import commons.manager.IFlowerSendManager;
    import commons.manager.ILoginManager;
    import commons.manager.INotifyManager;
    import commons.manager.ISceneManager;
    import commons.manager.IWindowManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.protos.ProtoInList;
    
    import mud.protos.FlowerProtoIn_SendLimInfo;
    import mud.protos.FlowerProtoIn_SentInfo;
    import mud.protos.FlowerProtoIn_ShowEffect;
    import mud.protos.FlowerProtoIn_UserSentInfoNotice;
    
    /**
     * 鲜花赠送管理器
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerSendManager implements IFlowerSendManager
    {
        private var _loginMgr:ILoginManager;
        private var _wm:IWindowManager;
        private var _sceneMgr:ISceneManager;
        private var _notifyMgr:INotifyManager;
        
        private var _flowerEffect:FlowerEffect;
        
        private var _selfSentNum:uint = 0;
        private var _totalSentNum:uint = 0;
        
        private var _bFirstTime:Boolean = true;
        
        
        public function FlowerSendManager()
        {
            _loginMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.LoginManager) as ILoginManager;
            _wm = ManagerHub.getInstance().getManager(ManagerGlobalName.WindowManager) as IWindowManager;
            _sceneMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.Scene3dManager) as ISceneManager;
            _notifyMgr = ManagerHub.getInstance().getManager(ManagerGlobalName.NotifyManager) as INotifyManager;
            
            _flowerEffect = FlowerEffect.getInstance();
            
            ProtoInList.getInstance().bind(FlowerProtoIn_SentInfo.HEAD, FlowerProtoIn_SentInfo);
            ProtoInList.getInstance().bind(FlowerProtoIn_SendLimInfo.HEAD, FlowerProtoIn_SendLimInfo);
            ProtoInList.getInstance().bind(FlowerProtoIn_UserSentInfoNotice.HEAD, FlowerProtoIn_UserSentInfoNotice);
            ProtoInList.getInstance().bind(FlowerProtoIn_ShowEffect.HEAD, FlowerProtoIn_ShowEffect);
            
            NetBus.getInstance().addCallback(FlowerProtoIn_SentInfo.HEAD, onRecvSentInfo);
            NetBus.getInstance().addCallback(FlowerProtoIn_SendLimInfo.HEAD, onRecvSendLimInfo);
            NetBus.getInstance().addCallback(FlowerProtoIn_UserSentInfoNotice.HEAD, onRecvUserSentInfoNotice);
            NetBus.getInstance().addCallback(FlowerProtoIn_ShowEffect.HEAD, onShowEffect);
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
            
            if (_bFirstTime && 0 == _selfSentNum)
            {
                _wm.open(WindowGlobalName.MSG_BOX, null, "点击飘下来的花瓣，可以给我们赠花哦！\np.s.: 每到一定的送花数量，会出现更浪漫的花雨哦~~");
                _bFirstTime = false;
            }
        }
        
        private function onRecvSendLimInfo(inc:FlowerProtoIn_SendLimInfo):void
        {
            if (!_loginMgr.isLogined)
                return;
            
            const averageTime:uint = inc.duration / inc.limitCount * 1000;
            _flowerEffect.fallFlowers(inc.limitCount, averageTime / 1.2, averageTime * 1.5); // 偏向于落慢一点
        }
        
        private function onRecvUserSentInfoNotice(inc:FlowerProtoIn_UserSentInfoNotice):void
        {
            var notice:String = StringUtil.substitute("{0}已经送给我们{1}朵鲜花，好感动啊！T_T", inc.name, inc.sentNum);
            _notifyMgr.showNotice(notice, function():void
            {
                _sceneMgr.playEffect(2);
            });
        }
        
        private function onShowEffect(inc:FlowerProtoIn_ShowEffect):void
        {
            var notice:String = StringUtil.substitute("全体朋友已经送给了我们{0}朵鲜花，太感动啦！QvQ", _totalSentNum);
            _notifyMgr.showNotice(notice, function():void
            {
                _sceneMgr.playEffect(1);
            });
        }
    }
}