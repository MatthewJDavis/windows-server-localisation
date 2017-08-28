Describe 'UK settings' {
  Context 'Timezone' {
    it 'should have the xTimezone module installed' {
      $result = Get-Module -Name 'xTimezone' -ListAvailable
      $result | Should Be $true
    }
    it 'should have the timezone set to GMT' {
      $result = Get-TimeZone 
      $result.Id | Should Be 'GMT Standard Time'
    }
  }
  Context 'Locale' {
    It 'Should have the locale set to EN-GB' {
      $result = Get-WinSystemLocale
      $result.Name | Should Be 'en-GB'
    }
  }
}