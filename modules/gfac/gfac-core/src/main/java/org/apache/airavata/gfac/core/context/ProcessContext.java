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

package org.apache.airavata.gfac.core.context;

import org.apache.airavata.common.utils.LocalEventPublisher;
import org.apache.airavata.gfac.core.cluster.RemoteCluster;
import org.apache.airavata.gfac.core.task.Task;
import org.apache.airavata.model.appcatalog.gatewayprofile.GatewayResourceProfile;
import org.apache.airavata.model.process.ProcessModel;
import org.apache.airavata.registry.cpi.AppCatalog;
import org.apache.airavata.registry.cpi.ExperimentCatalog;
import org.apache.curator.framework.CuratorFramework;

import java.util.List;
import java.util.Map;

public class ProcessContext {
	// process model
    private ExperimentCatalog experimentCatalog;
	private AppCatalog appCatalog;
	private CuratorFramework curatorClient;
	private LocalEventPublisher localEventPublisher;
	private final String processId;
	private final String gatewayId;
	private final String tokenId;
	private ProcessModel processModel;
	private String workingDir;
	private List<Task> taskChain;
	private GatewayResourceProfile gatewayResourceProfile;
	private RemoteCluster remoteCluster;
	private Map<String, String> sshProperties;

	public ProcessContext(String processId, String gatewayId, String tokenId) {
		this.processId = processId;
		this.gatewayId = gatewayId;
		this.tokenId = tokenId;
	}


	// Getters and Setters
	public ExperimentCatalog getExperimentCatalog() {
		return experimentCatalog;
	}

	public void setExperimentCatalog(ExperimentCatalog experimentCatalog) {
		this.experimentCatalog = experimentCatalog;
	}

	public AppCatalog getAppCatalog() {
		return appCatalog;
	}

	public void setAppCatalog(AppCatalog appCatalog) {
		this.appCatalog = appCatalog;
	}

	public String getGatewayId() {
		return gatewayId;
	}

	public String getTokenId() {
		return tokenId;
	}

	public String getProcessId() {
		return processId;
	}

	public CuratorFramework getCuratorClient() {
		return curatorClient;
	}

	public void setCuratorClient(CuratorFramework curatorClient) {
		this.curatorClient = curatorClient;
	}

	public LocalEventPublisher getLocalEventPublisher() {
		return localEventPublisher;
	}

	public void setLocalEventPublisher(LocalEventPublisher localEventPublisher) {
		this.localEventPublisher = localEventPublisher;
	}

	public ProcessModel getProcessModel() {
		return processModel;
	}

	public void setProcessModel(ProcessModel processModel) {
		this.processModel = processModel;
	}

	public String getWorkingDir() {
		return workingDir;
	}

	public void setWorkingDir(String workingDir) {
		this.workingDir = workingDir;
	}

	public List<Task> getTaskChain() {
		return taskChain;
	}

	public void setTaskChain(List<Task> taskChain) {
		this.taskChain = taskChain;
	}

	public GatewayResourceProfile getGatewayResourceProfile() {
		return gatewayResourceProfile;
	}

	public void setGatewayResourceProfile(GatewayResourceProfile gatewayResourceProfile) {
		this.gatewayResourceProfile = gatewayResourceProfile;
	}

	public RemoteCluster getRemoteCluster() {
		return remoteCluster;
	}

	public void setRemoteCluster(RemoteCluster remoteCluster) {
		this.remoteCluster = remoteCluster;
	}

	public Map<String, String> getSshProperties() {
		return sshProperties;
	}

	public void setSshProperties(Map<String, String> sshProperties) {
		this.sshProperties = sshProperties;
	}
}
