package commons.manager
{
    import commons.anim.IAnimation;
    import commons.manager.base.IManager;
    
    /**
     * 动画管理器
     * <br/>创建动画，并提供统一管理那些不手动控制的动画的接口
     * @author junho
     * <br/>Create: 2013.12.21
     */    
    public interface IAnimManager extends IManager
    {
        function createAnim(animType:String, rawData:Object):IAnimation;
        
        function addAnim(anim:IAnimation):void;
        
        function removeAnim(anim:IAnimation):void;
    }
}