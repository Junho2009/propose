package commons.manager
{
    import commons.manager.base.IManager;
    
    /**
     * 场景管理器
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public interface ISceneManager extends IManager
    {
        function playEffect(id:uint):void;
    }
}