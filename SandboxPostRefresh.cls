/**
* Author: Natarajan Periyasamy, Creation Technology Solutions
* Date: 10/01/2019
* Description: Class implements SandboxPostCopy Interface which will invoked automatically by Automated Process
**/
global class SandboxPostRefresh implements SandboxPostCopy {
    global void runApexClass(SandboxContext context) {
        SandboxPostRefreshHelper.executeBatch();
    }
}