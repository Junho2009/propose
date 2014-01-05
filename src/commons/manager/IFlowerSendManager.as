package commons.manager
{
    import commons.manager.base.IManager;
    
    /**
     * 鲜花赠送管理器
     * @author junho
     * <br/>Create: 2014.01.05
     */    
    public interface IFlowerSendManager extends IManager
    {
        /**
         * 个人赠花总数
         * @return uint
         * 
         */        
        function get selfSentNum():uint;
        
        /**
         * 全服赠花总数
         * @return uint
         * 
         */        
        function get totalSentNum():uint;
    }
}