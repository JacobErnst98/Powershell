<#PSScriptInfo

.AUTHOR Deruijter

.PROJECTURI https://stackoverflow.com/questions/23472027/how-is-first-day-of-week-determined-in-powershell/23475495#23475495

.RELEASENOTES
Apparently powershell parameter -uformat %V doesn't actually use any kind of 'first day of week' rule. It actually just shows the amount of '7 days' that have passed since the beginning of the year (starting at 1).
Using this information I made the following function that retrieves the same correct week number for each day in the week (sunday to saturday):
(Thanks to both @DavidBrabant and @vonPryz for the additional info I required)
This function basically gets the week number based on the nth Wednesday of the year and uses Sunday as the first day of the week (I haven't put time into changing that since this is actually the convention my company uses).
You could say it retrieves the week number based on the first week having at least 4 days in this year, and the first day of the week being Sunday.

.LICENSEURI
https://stackoverflow.com/help/licensing
https://creativecommons.org/licenses/by-sa/3.0/

.LICENSE
This solution was located on stackoverflow and written by a third party. 
Vital Project has no direct claim on this code.
According to stackoverflow TOS and the date of the original post the license would be
https://creativecommons.org/licenses/by-sa/3.0/


#> 
<#
.DESCRIPTION This function basically gets the week number based on the nth Wednesday of the year and uses Sunday as the first day of the week (I haven't put time into changing that since this is actually the convention my company uses) 
#>
Function Get-WeekOfYear($date)
{
    # Note: first day of week is Sunday
    $intDayOfWeek = (get-date -date $date).DayOfWeek.value__
    $daysToWednesday = (3 - $intDayOfWeek)
    $wednesdayCurrentWeek = ((get-date -date $date)).AddDays($daysToWednesday)

    # %V basically gets the amount of '7 days' that have passed this year (starting at 1)
    $weekNumber = get-date -date $wednesdayCurrentWeek -uFormat %V

    return $weekNumber
}

