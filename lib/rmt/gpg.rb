require 'English'
require 'fileutils'
require 'tmpdir'

class RMT::Gpg
  class RMT::Gpg::Exception < RuntimeError
  end

  def initialize(metadata_file:, key_file:, signature_file:, logger:)
    @metadata_file = metadata_file
    @key_file = key_file
    @signature_file = signature_file
    @logger = logger
  end

  def verify_signature
    @tmpdir = Dir.mktmpdir('rmt-mirror-gpg')
    @keyring = File.join(@tmpdir, 'keyring')

    run_import_key
    run_verify_signature

    true
  ensure
    FileUtils.rm_rf(@tmpdir)
  end

  protected

  def run_import_key
    cmd = "gpg --homedir #{@tmpdir} --no-default-keyring --keyring #{@keyring} --import #{@key_file} 2>&1"
    out = `#{cmd}`

    if $CHILD_STATUS.exitstatus != 0
      @logger.debug "GPG command: #{cmd}"
      @logger.debug "GPG output: #{out}"
      raise RMT::Gpg::Exception.new(_('GPG key import failed'))
    end
  end

  def run_verify_signature
    cmd = "gpg --homedir #{@tmpdir} --no-default-keyring --keyring #{@keyring} --verify #{@signature_file} #{@metadata_file} 2>&1"
    out = `#{cmd}`

    if $CHILD_STATUS.exitstatus != 0
      @logger.debug "GPG command: #{cmd}"
      @logger.debug "GPG output: #{out}"
      raise RMT::Gpg::Exception.new(_('GPG signature verification failed'))
    end
  end
end
