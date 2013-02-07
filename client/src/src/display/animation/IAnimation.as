package display.animation
{

    /**
     * 动画接口
     * @author Junho
     * <br/>Create: 2013.02.07
     */
    public interface IAnimation
    {
        /**
         * 从第一帧到最后一帧，完整的播放一次
         *
         */
        function play():void;

        /**
         * 立即停止动画的播放
         *
         */
        function stop():void;

        /**
         * 播放指定范围的帧组
         * @param beginFrame:uint 起始帧号
         * @param endFrame:uint 结尾帧号
         * @param isLoop:Boolean 是否循环播放
         *
         */
        function gotoAndPlay(beginFrame:uint, endFrame:uint
            , isLoop:Boolean):void;

        /**
         * 播放到指定的帧，完成后停止播放
         * @param targetFrame:uint 目标帧号
         *
         */
        function gotoAndStop(targetFrame:uint):void;
    }
}
