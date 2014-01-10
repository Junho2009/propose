package flowersend
{
    import commons.GlobalLayers;
    import commons.buses.InnerEventBus;
    import commons.buses.NetBus;
    import commons.manager.ITimerManager;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.IModule;
    
    import login.LoginEvent;
    
    import mud.protos.FlowerProtoOut_SendLimInfo;
    import mud.protos.FlowerProtoOut_SentInfo;
    
    /**
     * 鲜花赠送模块
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public class FlowerSendModule implements IModule
    {
        public function FlowerSendModule()
        {
            ManagerHub.getInstance().register(ManagerGlobalName.FlowerSendManager
                , new FlowerSendManager());
            
            InnerEventBus.getInstance().addEventListener(LoginEvent.LoginSuccessfully, onLogined);
        }
        
        public function get name():String
        {
            return "FlowerSendModule";
        }
        
        private function onLogined(e:LoginEvent):void
        {
            InnerEventBus.getInstance().removeEventListener(LoginEvent.LoginSuccessfully, onLogined);
            
            var tm:ITimerManager = ManagerHub.getInstance().getManager(ManagerGlobalName.TimerManager) as ITimerManager;
            tm.setTask(function():void
            {
                var flowerSendInfoView:FlowerSendInfoView = new FlowerSendInfoView();
                GlobalLayers.getInstance().msgLayer.addChild(flowerSendInfoView);
                
                // 请求数据
                NetBus.getInstance().send(new FlowerProtoOut_SentInfo());
                NetBus.getInstance().send(new FlowerProtoOut_SendLimInfo());
            }, 10000);
        }
    }
}