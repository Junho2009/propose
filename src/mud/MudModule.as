package mud
{
    import commons.manager.base.ManagerGlobalName;
    import commons.manager.base.ManagerHub;
    import commons.module.IModule;
    
    import mud.protos.base.MudProtoInManager;

    /**
     * 与文字mud相关的处理模块
     * @author Junho
     * <br/>Create: 2013.11.30
     */
    public class MudModule implements IModule
    {
        public function MudModule()
        {
            ManagerHub.getInstance().register(ManagerGlobalName.ProtoInManager
                , new MudProtoInManager());
        }
        
        public function get name():String
        {
            return "MudModule";
        }
    }
}