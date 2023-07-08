/*
 * Copyright (C) 2020 - 2022 Xilinx, Inc.
 * Copyright (C) 2023, Advanced Micro Devices, Inc.
 * SPDX-License-Identifier: Apache-2.0
 */

def logCommitIDs() {
    sh label: 'log commit IDs',
    script: '''
        idfile=${ws}/commitIDs
        pushd ${ws}/src
        echo -n "src : " >> ${idfile}
        git rev-parse HEAD >> ${idfile}
        popd
        pushd ${ws}/paeg-helper
        echo -n "paeg-helper : " >> ${idfile}
        git rev-parse HEAD >> ${idfile}
        popd
        cat ${idfile}
    '''
}

def createWorkDir() {
    sh label: 'create work dir',
    script: '''
        if [ ! -d ${work_dir} ]; then
            mkdir -p ${work_dir}
            cp -rf ${ws}/src/* ${work_dir}
        fi
    '''
}

def buildDesign() {
    sh label: 'build design',
    script: '''
        pushd ${work_dir}/${design}
        source ${setup} -r ${tool_release} && set -e
        ${lsf} make xsa JOBS=32
        popd
    '''
}

def deployDesign() {
    sh label: 'deploy design',
    script: '''
        if [ "${BRANCH_NAME}" == "${deploy_branch}" ]; then
            pushd ${work_dir}/${design}
            DST=${DEPLOYDIR}/${design}
            mkdir -p ${DST}
            cp -rf ./project/*.xsa ./project/*.runs/impl_1/*.bit ${DST}
            popd
            cp ${ws}/commitIDs ${DST}
        fi
    '''
}

pipeline {
    agent {
        label 'Build_Master'
    }
    environment {
        deploy_branch="2023.1"
        tool_release="2023.1"
        tool_build="daily_latest"
        auto_branch="2022.1"
        ws="${WORKSPACE}"
        setup="${ws}/paeg-helper/env-setup.sh"
        lsf="${ws}/paeg-helper/scripts/lsf"
        DEPLOYDIR="/wrk/paeg_builds/build-artifacts/kria-base-hardware/${tool_release}"
    }
    options {
        // don't let the implicit checkout happen
        skipDefaultCheckout true
        // retain logs for last 30 builds
        buildDiscarder(logRotator(numToKeepStr: '30'))
    }
    triggers {
        cron(env.BRANCH_NAME == '2023.1' ? 'H 21 * * *' : '')
    }
    stages {
        stage('Clone Repos') {
            steps {
                // checkout main source repo
                checkout([
                    $class: 'GitSCM',
                    branches: scm.branches,
                    doGenerateSubmoduleConfigurations: scm.doGenerateSubmoduleConfigurations,
                    extensions: scm.extensions +
                    [
                        [$class: 'RelativeTargetDirectory', relativeTargetDir: 'src'],
                        [$class: 'ChangelogToBranch', options: [compareRemote: 'origin', compareTarget: env.deploy_branch]]
                    ],
                    userRemoteConfigs: scm.userRemoteConfigs
                ])
                // checkout paeg-automation helper repo
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: auto_branch]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions:
                    [
                        [$class: 'CleanCheckout'],
                        [$class: 'RelativeTargetDirectory', relativeTargetDir: 'paeg-helper']
                    ],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        credentialsId: '01d4faf7-fb5a-4bd9-b300-57ac0bfc7991',
                        url: 'https://gitenterprise.xilinx.com/PAEG/paeg-automation.git'
                    ]]
                ])
                logCommitIDs()
            }
        }
        stage('Vivado Builds') {
            parallel {
                stage('kria_som/k26') {
                    environment {
                        design="kria_som/k26"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/kria_som/k26/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('k26_starter_kits/base') {
                    environment {
                        design="k26_starter_kits/base"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/k26_starter_kits/base/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('k26_starter_kits/base_gpio_bram') {
                    environment {
                        design="k26_starter_kits/base_gpio_bram"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/k26_starter_kits/base_gpio_bram/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('k26_starter_kits/kr260') {
                    environment {
                        design="k26_starter_kits/kr260"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/k26_starter_kits/kr260/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('k26_starter_kits/kv260') {
                    environment {
                        design="k26_starter_kits/kv260"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/k26_starter_kits/kv260/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('kria_som/k24c') {
                    environment {
                        design="kria_som/k24c"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/kria_som/k24c/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('kria_som/k24i') {
                    environment {
                        design="kria_som/k24i"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/kria_som/k24i/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('k24_starter_kits/base') {
                    environment {
                        design="k24_starter_kits/base"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/k24_starter_kits/base/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('k24_starter_kits/kd240') {
                    environment {
                        design="k24_starter_kits/kd240"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/k24_starter_kits/kd240/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
                stage('k24_starter_kits/kv240') {
                    environment {
                        design="k24_starter_kits/kv240"
                        work_dir="${ws}/build/${design}"
                        PAEG_LSF_MEM=65536
                        PAEG_LSF_QUEUE="long"
                    }
                    when {
                        anyOf {
                            changeset "**/k24_starter_kits/kv240/**"
                            triggeredBy 'TimerTrigger'
                            triggeredBy 'UserIdCause'
                        }
                    }
                    steps {
                        createWorkDir()
                        buildDesign()
                    }
                    post {
                        success {
                            deployDesign()
                        }
                    }
                }
            
            }
        }
    }
    post {
        cleanup {
            cleanWs()
        }
    }
}
