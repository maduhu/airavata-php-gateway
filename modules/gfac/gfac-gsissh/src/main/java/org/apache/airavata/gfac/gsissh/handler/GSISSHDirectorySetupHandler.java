/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/
package org.apache.airavata.gfac.gsissh.handler;

import org.apache.airavata.gfac.GFacException;
import org.apache.airavata.gfac.core.context.JobExecutionContext;
import org.apache.airavata.gfac.core.handler.AbstractRecoverableHandler;
import org.apache.airavata.gfac.core.handler.GFacHandlerException;
import org.apache.airavata.gfac.core.utils.GFacUtils;
import org.apache.airavata.gfac.gsissh.security.GSISecurityContext;
import org.apache.airavata.gfac.gsissh.util.GFACGSISSHUtils;
import org.apache.airavata.gsi.ssh.api.Cluster;
import org.apache.airavata.model.workspace.experiment.*;
import org.apache.airavata.registry.cpi.ChildDataType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Properties;

public class GSISSHDirectorySetupHandler extends AbstractRecoverableHandler {
      private static final Logger log = LoggerFactory.getLogger(GSISSHDirectorySetupHandler.class);

	public void invoke(JobExecutionContext jobExecutionContext) throws GFacHandlerException {
        try {
            String hostAddress = jobExecutionContext.getHostName();
            if (jobExecutionContext.getSecurityContext(hostAddress) == null) {
                GFACGSISSHUtils.addSecurityContext(jobExecutionContext);
            }
        } catch (Exception e) {
        	 try {
  				GFacUtils.saveErrorDetails(jobExecutionContext, e.getLocalizedMessage(), CorrectiveAction.CONTACT_SUPPORT, ErrorCategory.AIRAVATA_INTERNAL_ERROR);
  			} catch (GFacException e1) {
  				 log.error(e1.getLocalizedMessage());
  			}
        	throw new GFacHandlerException("Error while creating SSHSecurityContext", e, e.getLocalizedMessage());
        }

        log.info("Setup SSH job directorties");
        super.invoke(jobExecutionContext);
        makeDirectory(jobExecutionContext);
	}
	private void makeDirectory(JobExecutionContext jobExecutionContext) throws GFacHandlerException {
        Cluster cluster = null;
        try {
            String hostAddress = jobExecutionContext.getHostName();
            cluster = ((GSISecurityContext) jobExecutionContext.getSecurityContext(hostAddress)).getPbsCluster();
            if (cluster == null) {
                try {
                    GFacUtils.saveErrorDetails(jobExecutionContext, "Security context is not set properly", CorrectiveAction.CONTACT_SUPPORT, ErrorCategory.AIRAVATA_INTERNAL_ERROR);
                } catch (GFacException e1) {
                    log.error(e1.getLocalizedMessage());
                }
                throw new GFacHandlerException("Security context is not set properly");
            } else {
                log.info("Successfully retrieved the Security Context");
            }

            String workingDirectory = jobExecutionContext.getWorkingDir();
            cluster.makeDirectory(workingDirectory);
            if(!jobExecutionContext.getInputDir().equals(workingDirectory))
                cluster.makeDirectory(jobExecutionContext.getInputDir());
            if(!jobExecutionContext.getOutputDir().equals(workingDirectory))
            	cluster.makeDirectory(jobExecutionContext.getOutputDir());
            
            DataTransferDetails detail = new DataTransferDetails();
            TransferStatus status = new TransferStatus();
            status.setTransferState(TransferState.DIRECTORY_SETUP);
            detail.setTransferStatus(status);
            detail.setTransferDescription("Working directory = " + workingDirectory);

            registry.add(ChildDataType.DATA_TRANSFER_DETAIL, detail, jobExecutionContext.getTaskData().getTaskID());

		} catch (Exception e) {
			DataTransferDetails detail = new DataTransferDetails();
			TransferStatus status = new TransferStatus();
			detail.setTransferDescription(e.getLocalizedMessage());
			status.setTransferState(TransferState.FAILED);
			detail.setTransferStatus(status);
			try {
				registry.add(ChildDataType.DATA_TRANSFER_DETAIL, detail, jobExecutionContext.getTaskData().getTaskID());
				GFacUtils.saveErrorDetails(jobExecutionContext, e.getLocalizedMessage(), CorrectiveAction.CONTACT_SUPPORT, ErrorCategory.FILE_SYSTEM_FAILURE);
			} catch (Exception e1) {
				throw new GFacHandlerException("Error persisting status", e1, e1.getLocalizedMessage());
			}
			throw new GFacHandlerException("Error executing the Handler: " + GSISSHDirectorySetupHandler.class, e);
		}
	}

    public void recover(JobExecutionContext jobExecutionContext) throws GFacHandlerException {
         this.invoke(jobExecutionContext);
    }

    public void initProperties(Properties properties) throws GFacHandlerException {

    }
}
