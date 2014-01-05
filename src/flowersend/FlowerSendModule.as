package flowersend
{
    import commons.GlobalLayers;
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.IModule;
    
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
            
            var flowerSendInfoView:FlowerSendInfoView = new FlowerSendInfoView();
            GlobalLayers.getInstance().msgLayer.addChild(flowerSendInfoView);
        }
        
        public function get name():String
        {
            return "FlowerSendModule";
        }
    }
}