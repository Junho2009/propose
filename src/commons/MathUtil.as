package commons
{
    /**
     * 数学工具
     * @author junho
     * <br/>Create: 2013.12.20
     */    
    public final class MathUtil
    {
        public static function randomInt(min:int, max:int):int
        {
            return min + (Math.random() * (max - min + 1) >> 0);
        }
    }
}