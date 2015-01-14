namespace: jenkins.integration.flows

imports:
  ops: user.ops

flow:
  name: run_app
  workflow:
    start_app:
      do:
        ops.run_jar:
          - jar_path: "'/home/orius123/dev/jenkins/spring-boot-tomcat-mysql-app/target/spring-boot-sample-tomcat-1.2.0.RELEASE.jar'"

    wait_for_app_to_start:
      do:
        ops.verify_app_is_up:
          - host: "'localhost'"
          - port: "'8080'"
          - max_seconds_to_wait: "'60'"

    task3:
      do:
        ops.print:
          - text: "'foo'"

    kill_app:
      do:
        ops.kill_child_processes:

    wait_for_up_to_shutdown:
      do:
        ops.wait_for_up_to_shutdown:
          - host: "'localhost'"
          - port: "'8080'"
          - max_seconds_to_wait: "'10'"
