package display.animation
{

    /**
     * 动画帧接口
     * @author Junho
     * <br/>Create: 2013.02.07
     */
    public interface IFrame
    {
        /**
         * 帧宽度
         * @return Number
         *
         */
        function get width():Number;

        /**
         * 帧高度
         * @return Number
         *
         */
        function get height():Number;

        /**
         * 销毁帧
         *
         */
        function dispose():void;
    }
}
