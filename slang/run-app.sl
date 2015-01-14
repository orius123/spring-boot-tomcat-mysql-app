namespace: jenkins.integration.flows

imports:
  ops: user.ops

flow:
  name: run_app

  inputs:
    - build_dir

  workflow:
    start_app:
      do:
        ops.run_jar:
          - jar_path: build_dir + "/target/spring-boot-sample-tomcat-1.2.0.RELEASE.jar"

    wait_for_app_to_start:
      do:
        ops.verify_app_is_up:
          - host: "'localhost'"
          - port: "'9002'"
          - max_seconds_to_wait: "'60'"

    test:
      do:
        ops.print:
          - text: "'foo'"

    kill_app:
      do:
        ops.send_shutdown:

    wait_for_up_to_shutdown:
      do:
        ops.wait_for_up_to_shutdown:
          - host: "'localhost'"
          - port: "'9002'"
          - max_seconds_to_wait: "'10'"
