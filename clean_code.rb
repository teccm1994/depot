if (deletePage(page) == E_OK)

# Check to see if the employee is eligible for full benefits.
if ((employee.flags & HOURLY_FLAG) && (employee.age > 65))

if(employee.isEligibleForBenefits())

# does the module from the global list <mod> depend on the subsystem we are part of?
if (smodule.getDependSubsystems().contains(subSysMod.getSubSystem()))

ArrayList moduleDependees = smodule.getDependSubsystems();
String ourSubSystem = subSysMod.getSubSystem();
if (moduleDependees.contains(ourSubSystem))

#具象点
public class Point{
	public double x;
	public double y;
}
#抽象点
public interface Point{
	double getX();
	double getY();
	void setCartesian(double x, double y);
	double getR();
	double getTheta();
	void setPolar(double r, double theta);
}
#隐藏实现并非只是在变量之间放上一个函数层,而是关乎抽象;类并非是用取值器和赋值器将其变量推向外间,而是暴露抽象接口,
#以便用户无需了解数据的实现就能操作数据本体.

