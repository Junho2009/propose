package display.animation
{

    /**
     * 动画管理器接口
     * @author Junho
     * <br/>Create: 2013.02.07
     */
    public interface IAnimationMgr
    {
        function addAnimation(ani:IAnimation):void;

        function removeAnimation(ani:IAnimation):void;
    }
}
