namespace: user.ops

operations:
  - print:
      inputs:
        - text
      action:
        python_script: print text + "bar"
      results:
        - SUCCESS: 1==1

  - run_jar:
      inputs:
        - jar_path
      action:
        python_script: |
          from subprocess import Popen
          Popen(["java", "-jar", jar_path])
      results:
        - SUCCESS

  - send_shutdown:
#      inputs:
#        - process_name
      action:
        python_script: |
          import urllib
          urllib.urlopen(url = "http://localhost:9002/shutdown", data="")
      results:
        - SUCCESS

  - verify_app_is_up:
        inputs:
          - host
          - port
          - max_seconds_to_wait
        action:
          python_script: |
            import urllib2
            import time
            url = "http://" + host + ":" + port
            count = 0
            returnResult = False
            while (( count < max_seconds_to_wait ) and ( not returnResult )):
              try:
                result = urllib2.urlopen(url)
              except Exception :
                 count = count + 1
                 time.sleep(1)
              else:
                  code = result.getcode()
                  count = max_seconds_to_wait
                  if code == 200 :
                    returnResult = True
        outputs:
          - errorMessage: "'Application is not Up , after ' + count + ' attempts to ping .'"
        results:
          - SUCCESS: returnResult == 'True'
          - FAILURE

  - wait_for_up_to_shutdown:
        inputs:
          - host
          - port
          - max_seconds_to_wait
        action:
          python_script: |
            import urllib2
            import time
            url = "http://" + host + ":" + port
            count = 0
            down = False
            while (( count < max_seconds_to_wait ) and ( not down )):
              try:
                result = urllib2.urlopen(url)
              except Exception as e:
                print e.reason
                down = True
              else:
                count = count + 1
                time.sleep(1)
        outputs:
          - errorMessage: "'Application is not Down , after ' + count + ' attempts to ping .'"
        results:
          - SUCCESS: down == 'True'
          - FAILURE

  - check_postgres_is_up:
          inputs:
            - host
            - port: "'22'"
            - username
            - password
            - privateKeyFile: "''"
            - arguments: "''"
            - command: "'psql --version'"
            - characterSet: "'UTF-8'"
            - pty: "'false'"
            - timeout: "'90000'"
            - closeSession: "'false'"
          action:
            java_action:
              className: org.openscore.content.ssh.actions.SSHShellCommandAction
              methodName: runSshShellCommand
          outputs:
            - additionalInformation: returnResult
            - errorMessage:  STDERR if returnCode == '0' else returnResult
          results:
            - SUCCESS : returnCode == '0' and returnResult == 'psql (PostgreSQL) 9.3.2\n'
            - FAILURE
