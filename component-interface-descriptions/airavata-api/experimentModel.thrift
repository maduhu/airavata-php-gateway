/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */

include "computeResourceModel.thrift"
include "applicationInterfaceModel.thrift"

namespace java org.apache.airavata.model.workspace.experiment
namespace php Airavata.Model.Workspace.Experiment
namespace cpp apache.airavata.model.workspace.experiment
namespace py apache.airavata.model.workspace.experiment

/*
 * This file describes the definitions of the.airavata.registry.core.experiment.Data Structures. Each of the
 *   language specific Airavata Client SDK's will translate this neutral data model into an
 *   appropriate form for passing to the Airavata Server Execution API Calls.
 * 
 * The Experiment data model is divided into 6 categories: experiment metadata, experiment configuration
 *   data, experiment generated data, experiment monitoring data, provenance data and error handling data.
 *
 *   Experiment Metadata:
 *     this structure holds the owner of the experiment, name, description, creation and last update times,
 *     last known status, and if is private to the user or shared publicly. 
 *    FIXME: To start with, we will not define this but populate it inferring data from other structures. This
 *    structure needs revisiting once the API gets used.
 * 
 *  Experiment Configuration Data:
 *     this structure will contain all user provided configuration data.
 * 
 *  Experiment Generated Data:
 *     this structure describes all intermediate and output data generated by executing the experiment.
 * 
 *  Experiment Monitoring Data:
 *     this structure contains fine grained experiment status information.
 *
 *  Experiment Summary Data: 
 *     this is derived information from all experiment objects to provide a quick summary.
 *
*/

const string DEFAULT_ID = "DO_NOT_SET_AT_CLIENTS"
const string DEFAULT_PROJECT_NAME = "DEFAULT"
const string SINGLE_APP_NODE_NAME = "SINGLE_APP_NODE"

enum ExperimentState {
    CREATED,
    VALIDATED,
    SCHEDULED,
    LAUNCHED,
    EXECUTING,
    CANCELING,
    CANCELED,
    SUSPENDED,
    COMPLETED,
    FAILED,
    UNKNOWN
}

enum ExperimentSearchFields {
    EXPERIMENT_NAME,
    EXPERIMENT_DESC,
    APPLICATION_ID,
    FROM_DATE,
    TO_DATE,
    STATUS
}

struct ExperimentStatus {
    1: required ExperimentState experimentState,
    2: optional i64 timeOfStateChange
}

enum WorkflowNodeState {
    INVOKED,
    EXECUTING,
    CANCELING,
    CANCELED,
    SUSPENDED,
    COMPLETED,
    FAILED,
    UNKNOWN
}

struct WorkflowNodeStatus {
    1: required WorkflowNodeState workflowNodeState,
    2: optional i64 timeOfStateChange
}

enum TaskState {
    WAITING,
    STARTED,
    PRE_PROCESSING,
    CONFIGURING_WORKSPACE,
    INPUT_DATA_STAGING,
    OUTPUT_DATA_STAGING,
    POST_PROCESSING,
    EXECUTING,
    CANCELING,
    CANCELED,
    COMPLETED,
    FAILED,
    UNKNOWN
}

struct TaskStatus {
    1: required TaskState executionState,
    2: optional i64 timeOfStateChange
}

enum JobState {
    SUBMITTED,
    UN_SUBMITTED,
    SETUP,
    QUEUED,
    ACTIVE,
    COMPLETE,
    CANCELING,
    CANCELED,
    FAILED,
    HELD,
    SUSPENDED,
    UNKNOWN
}

struct JobStatus {
    1: required JobState jobState,
    2: optional i64 timeOfStateChange
}

enum TransferState {
    DIRECTORY_SETUP,
    UPLOAD,
    DOWNLOAD,
    ACTIVE,
    COMPLETE,
    STDOUT_DOWNLOAD,
    STDERROR_DOWNLOAD,
    CANCELING,
    CANCELED,
    FAILED,
    HELD,
    SUSPENDED,
    UNKNOWN
}

struct TransferStatus {
    1: required TransferState transferState,
    2: optional i64 timeOfStateChange
}

struct ApplicationStatus {
    1: required string applicationState,
    2: optional i64 timeOfStateChange
}

enum ActionableGroup {
    RESOURCE_ADMINS,
    AIRAVATA_ADMINS,
    GATEWAYS_ADMINS,
    USER,
    CANNOT_BE_DETERMINED
}

enum ErrorCategory {
    FILE_SYSTEM_FAILURE,
    APPLICATION_FAILURE,
    RESOURCE_NODE_FAILURE,
    DISK_FULL,
    INSUFFICIENT_ALLOCATION,
    SYSTEM_MAINTENANCE,
    AIRAVATA_INTERNAL_ERROR,
    CANNOT_BE_DETERMINED
}

enum CorrectiveAction {
    RETRY_SUBMISSION,
    CONTACT_SUPPORT,
    CANNOT_BE_DETERMINED
}

/**
 * A structure holding the Computational Resource Scheduling.
 *
*/
struct ComputationalResourceScheduling {
    1: optional string resourceHostId,
    2: optional i32 totalCPUCount,
    3: optional i32 nodeCount,
    4: optional i32 numberOfThreads,
    5: optional string queueName,
    6: optional i32 wallTimeLimit,
    7: optional i32 jobStartTime,
    8: optional i32 totalPhysicalMemory,
    9: optional string computationalProjectAccount,
    10: optional string chassisName
}

/**
 * A structure holding specified input data handling.
 *
*/
struct AdvancedInputDataHandling {
    1: optional bool stageInputFilesToWorkingDir = 0,
    2: optional string parentWorkingDirectory,
    3: optional string uniqueWorkingDirectory,
    4: optional bool cleanUpWorkingDirAfterJob = 0
}

/**
 * A structure holding specified output data handling.
 *
*/
struct AdvancedOutputDataHandling {
    2: optional string outputDataDir,
    3: optional string dataRegistryURL,
    4: optional bool persistOutputData = 1
}

/**
 * A structure holding Quality of Service Parameters.
 *
*/
struct QualityOfServiceParams {
    1: optional string startExecutionAt,
    2: optional string executeBefore,
    3: optional i32 numberofRetries
}

/**
 * A structure holding the experiment configuration.
 *
 *
*/
struct UserConfigurationData {
    1: required bool airavataAutoSchedule = 0,
    2: required bool overrideManualScheduledParams = 0,
    3: optional bool shareExperimentPublicly = 0,
    4: optional ComputationalResourceScheduling computationalResourceScheduling,
    5: optional AdvancedInputDataHandling advanceInputDataHandling,
    6: optional AdvancedOutputDataHandling advanceOutputDataHandling,
    7: optional QualityOfServiceParams qosParams,
    8: optional bool throttleResources = 0,
    9: optional string userDN,
    10: optional bool generateCert = 0 
}

struct ErrorDetails {
    1: required string errorID = DEFAULT_ID,
    2: optional i64 creationTime,
    3: optional string actualErrorMessage,
    4: optional string userFriendlyMessage,
    5: optional ErrorCategory errorCategory,
    6: optional bool transientOrPersistent = 0,
    7: optional CorrectiveAction correctiveAction,
    8: optional ActionableGroup actionableGroup,
    9: optional list<string> rootCauseErrorIdList
}

struct JobDetails {
    1: required string jobID = DEFAULT_ID,
    2: required string jobDescription,
    3: optional i64 creationTime,
    4: optional JobStatus jobStatus,
    5: optional ApplicationStatus applicationStatus,
    6: optional list<ErrorDetails> errors,
    7: optional string computeResourceConsumed,
    8: optional string jobName,
    9: optional string workingDir
}

struct DataTransferDetails {
    1: required string transferID = DEFAULT_ID,
    2: optional i64 creationTime,
    3: required string transferDescription,
    4: optional TransferStatus transferStatus,
}

/**
 * A structure holding the actual execution context decided based on user provided configuration data or system inferred
 *   information from scheduling and QoS parameters. One experiment can have multiple tasks. Each tasks results in
 *   data transfers and jobs
 *
*/
struct TaskDetails {
    1: required string taskID = DEFAULT_ID,
    2: optional i64 creationTime,
    3: optional string applicationId,
    4: optional string applicationVersion,
    5: optional string applicationDeploymentId,
    6: optional list<applicationInterfaceModel.InputDataObjectType> applicationInputs,
    7: optional list<applicationInterfaceModel.OutputDataObjectType> applicationOutputs,
    8: optional ComputationalResourceScheduling taskScheduling,
    9: optional AdvancedInputDataHandling advancedInputDataHandling,
    10: optional AdvancedOutputDataHandling advancedOutputDataHandling,
    11: optional TaskStatus taskStatus,
    12: optional list<JobDetails> jobDetailsList,
    13: optional list<DataTransferDetails> dataTransferDetailsList,
    14: optional list<ErrorDetails> errors,
    15: optional bool enableEmailNotification,
    16: optional list<string> emailAddresses,
}

enum ExecutionUnit {
	INPUT,
	APPLICATION,
	OUTPUT,
	OTHER
}


/**
* A structure holding the node data.
* nodeInstanceId - unique node identifier for each run
*/
struct WorkflowNodeDetails {
    1: required string nodeInstanceId = DEFAULT_ID,
    2: optional i64 creationTime,
    3: required string nodeName = SINGLE_APP_NODE_NAME,
    4: required ExecutionUnit executionUnit = ExecutionUnit.APPLICATION,
    5: optional string executionUnitData,
    6: optional list<applicationInterfaceModel.InputDataObjectType> nodeInputs,
    7: optional list<applicationInterfaceModel.OutputDataObjectType> nodeOutputs,
    8: optional WorkflowNodeStatus workflowNodeStatus,
    9: optional list<TaskDetails> taskDetailsList,
    10: optional list<ErrorDetails> errors
}

/**
* This data structure can be used to store the validation results
* captured during validation step and during the launchExperiment
* operation it can be easilly checked to see the errors occured
* during the experiment launch operation
**/

struct ValidatorResult {
    1: required bool result,
    2: optional string errorDetails
}


struct ValidationResults {
    1: required bool validationState,
    2: required list<ValidatorResult> validationResultList
}
/**
 * A structure holding the experiment metadata and its child models.
 *
 * userName:
 *   The user name of the targeted gateway end user on whose behalf the experiment is being created.
 *     the associated gateway identity can only be inferred from the security hand-shake so as to avoid
 *     authorized Airavata Clients mimicking an unauthorized request. If a gateway is not registered with
 *     Airavata, an authorization exception is thrown.
 *
 * experimentName:
 *   The name of the experiment as defined by the user. The name need not be unique as uniqueness is enforced
 *      by the generated experiment id.
 *
 * experimentDescription:
 *    The verbose description of the experiment. This is an optional parameter.
*/

struct Experiment {
    1: required string experimentID = DEFAULT_ID,
    2: required string projectID = DEFAULT_PROJECT_NAME,
    3: optional i64 creationTime,
    4: required string userName,
    5: required string name,
    6: optional string description,
    7: optional string applicationId,
    8: optional string applicationVersion,
    9: optional string workflowTemplateId,
    10: optional string workflowTemplateVersion,
    11: optional string gatewayExecutionId,
    12: optional bool enableEmailNotification,
    13: optional list<string> emailAddresses,
    14: optional UserConfigurationData userConfigurationData,
    15: optional string workflowExecutionInstanceId,
    16: optional list<applicationInterfaceModel.InputDataObjectType> experimentInputs,
    17: optional list<applicationInterfaceModel.OutputDataObjectType> experimentOutputs,
    18: optional ExperimentStatus experimentStatus,
    19: optional list<WorkflowNodeStatus> stateChangeList,
    20: optional list<WorkflowNodeDetails> workflowNodeDetailsList,
    21: optional list<ErrorDetails> errors
}

struct ExperimentSummary {
    1: required string experimentID,
    2: required string projectID,
    3: optional i64 creationTime,
    4: required string userName,
    5: required string name,
    6: optional string description,
    7: optional string applicationId,
    8: optional ExperimentStatus experimentStatus,
}
