package commons.manager
{
    import commons.manager.base.IManager;
    
    /**
     * 登录管理器
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public interface ILoginManager extends IManager
    {
        function get isLogined():Boolean;
        
        function get userName():String;
    }
}